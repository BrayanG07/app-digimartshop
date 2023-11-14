import 'dart:async';

import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/environment/environment.dart';
import 'package:digimartbox/src/models/order/order_list_user.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ClientOrdersMapController extends GetxController {
  Socket socket = io('${Environment.apiUrl}orders/delivery',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build()
  );

  OrderListUser order = OrderListUser.fromJson(Get.arguments['order']);
  OrderProvider orderProvide = OrderProvider();
  CameraPosition initialPosition = const CameraPosition(
      target: LatLng(15.492723333333334, -87.99911333333333),
      zoom: 14
  );

  Completer<GoogleMapController> mapController = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  // // ? PARA TRAZAR LA RUTA
  // Set<Polyline> polylines = <Polyline>{}.obs;
  // List<LatLng> points = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    await updateLocation();
    connectAndListen();
  }

  @override
  void onClose() {
    super.onClose();
    socket.disconnect(); // CERRAMOS EL SOCKET
  }

  void connectAndListen() {
    socket.connect();

    socket.onConnect((data) => print('CONNECTED_WEBSOCKET'));
    socket.onDisconnect((_) => print('DISCONECTED_WEBSOCKET'));
    listenPosition();
  }

  void listenPosition() {
    socket.on('position/${order.idOrder}', (data) {
      addMarker('delivery', data['lat'], data['lng'], 'Repartidor', '', deliveryMarker!);
      animateCameraPosition(data['lat'], data['lng'], 16);
    });
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, path);

    return descriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title, content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;
    if (markerId == 'delivery') update();
  }

  Future<void> updateLocation() async {
    try {
      deliveryMarker = await createMarkerFromAssets('assets/img/icon_delivery_map.png');
      homeMarker = await createMarkerFromAssets('assets/img/icon_home_map.png');
      double latClient = double.parse(order.latitude);
      double lngClient = double.parse(order.longitude);
      double latDelivery = order.userDelivery!.latitude;
      double lngDelivery = order.userDelivery!.longitude;

      // ? PARA TRAZAR O DIBUJAR LA RUTA
      // LatLng to = LatLng(latDelivery, lngDelivery);
      // LatLng from = LatLng(latClient, lngClient);
      // setPolylines(from, to);

      addMarker('home', latClient, lngClient, 'Mi Ubicación', '', homeMarker!);
      addMarker('delivery', latDelivery, lngDelivery, 'Repartidor', '', deliveryMarker!);
      animateCameraPosition(latDelivery, lngDelivery, 15);

    } catch(e) {
      AlertHandler.getAlertWarning('Estamos teniendo problemas al actualizar la ubicación');
    }
  }

  // Future<void> setPolylines(LatLng from, LatLng to) async {
  //   PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
  //   PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
  //
  //   PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
  //     Constants.apiKeyMaps,
  //     pointFrom,
  //     pointTo,
  //   );
  //
  //   for (PointLatLng point in result.points) {
  //     points.add(LatLng(point.latitude, point.longitude));
  //   }
  //   Polyline polyline = Polyline(
  //     polylineId: const PolylineId('poly'),
  //     color: Constants.colorPrimary,
  //     points: points,
  //     width: 6,
  //   );
  //
  //   polylines.add(polyline);
  //   // REFRESCAMOS LA VISTA PARA PODER VER EL POLYLINE, LOS MARKERS Y LA UBICACIÓN, ESTO VA DE LA MANO CON EL GetBuilder<ClientOrdersMapController>
  //   update();
  // }

  void centerPosition() async {
    if (order.longitude.isNotEmpty && order.latitude.isNotEmpty) {
      double latClient = double.parse(order.latitude);
      double lngClient = double.parse(order.longitude);
      animateCameraPosition(latClient, lngClient, 15);
    }
  }

  void callNumber() async{
    String number = order.userDelivery!.user.phone ?? '';

    if (number.isNotEmpty) {
      await FlutterPhoneDirectCaller.callNumber(number);
    }
  }

  Future<void> animateCameraPosition(double latitude, double longitude, double zoom) async {
    try {
      GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: zoom,
            bearing: 0
        ),
      ));
    } catch(e) {
      AlertHandler.getAlertWarning('Estamos teniendo problemas al reposicionar la ubicación');
    }
  }

  void onMapCreate(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    mapController.complete(controller);
  }
}