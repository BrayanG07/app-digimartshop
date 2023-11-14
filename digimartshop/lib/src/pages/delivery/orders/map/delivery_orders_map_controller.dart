import 'dart:async';

import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/environment/environment.dart';
import 'package:digimartbox/src/models/order/order_list_delivery.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';

class DeliveryOrdersMapController extends GetxController {
  Socket socket = io('${Environment.apiUrl}orders/delivery',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build()
  );

  OrderListDelivery order = OrderListDelivery.fromJson(Get.arguments['order'] ?? {});
  OrderProvider orderProvide = OrderProvider();
  CameraPosition initialPosition = const CameraPosition(
  target: LatLng(15.492723333333334, -87.99911333333333),
  zoom: 14
  );

  Completer<GoogleMapController> mapController = Completer();
  Position? position;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  // // ? PARA TRAZAR LA RUTA
  // Set<Polyline> polylines = <Polyline>{}.obs;
  // List<LatLng> points = [];

  // Coordenadas en tiempo real
  StreamSubscription? positionSubscribe;

  double distanceBetween = 0.0;

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkGPS();
    connectAndListen();
  }

  @override
  void onClose() {
    super.onClose();
    positionSubscribe?.cancel(); // CERRARMOS EL EVENTO DE ESCUCHA EN TIEMPO REAL AL SALIR DE LA PANTALLA
  }

  void connectAndListen() {
    socket.connect();

    socket.onConnect((data) => print('CONNECTED_WEBSOCKET'));
    socket.onDisconnect((_) => print('DISCONECTED_WEBSOCKET'));
  }

  void emitPosition() {
    if (position != null && socket.connected) {
      socket.emit('position', {
        'lat': position!.latitude,
        'lng': position!.longitude,
        'orderId': order.idOrder
      });
    }
  }

  void isCloseToDeliveryPosition() {
    if (position != null) {
      double latClient = double.parse(order.latitude);
      double lngClient = double.parse(order.longitude);

      distanceBetween = Geolocator.distanceBetween(
          position!.latitude,
          position!.longitude,
          latClient,
          lngClient
      );

      closeSocket();
    }
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

  Future<void> checkGPS() async {
    deliveryMarker = await createMarkerFromAssets('assets/img/icon_delivery_map.png');
    homeMarker = await createMarkerFromAssets('assets/img/icon_home_map.png');

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled == true) {
      await updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS == true) {
        await updateLocation();
      }
    }
  }

  Future<void> updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      await saveLocationDelivery();

      if (position != null) {
        double latClient = double.parse(order.latitude);
        double lngClient = double.parse(order.longitude);
        addMarker('home', latClient, lngClient, 'Cliente', '', homeMarker!);

        // ? PARA TRAZAR O DIBUJAR LA RUTA
        // LatLng from = LatLng(position!.latitude, position!.longitude);
        // LatLng to = LatLng(latClient, lngClient);
        // setPolylines(from, to);

        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1
        );

        positionSubscribe = Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position currentPosition) {
              position = currentPosition;
              addMarker('delivery', position!.latitude, position!.longitude, 'Tu posición', '', deliveryMarker!);
              animateCameraPosition(position!.latitude, position!.longitude);
              emitPosition();
              isCloseToDeliveryPosition();
            });
      }
    } catch(e) {
      AlertHandler.getAlertWarning('Estamos teniendo problemas al actualizar la ubicación');
    }
  }

  Future<void> saveLocationDelivery() async {
    if (position != null) {
      await orderProvide.updateLocationDelivery(position!.latitude, position!.longitude);
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
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
    }
  }

  void callNumber() async{
    String number = order.user.phone ?? '';
    if (number.isNotEmpty) {
      await FlutterPhoneDirectCaller.callNumber(number);
    }
  }

  Future animateCameraPosition(double latitude, double longitude) async {
    try {
      GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> updateOrderToDelivered() async {
    if (distanceBetween <= 100) { // 100 metros
      closeSocket();
      Response response = await orderProvide.changeOrderToEnd(order.idOrder);
      if (response.statusCode == 200) {
        AlertHandler.getAlertSuccess('El pedido ha sido entregado');
        Get.offNamedUntil(ConfigRoute.keyDeliveryHome, (route) => false);
      } else {
        AlertHandler.getAlertWarning('Ha ocurrido un error al intentar entregar el pedido');
      }
    } else {
      AlertHandler.getAlertWarning('No estás cerca del cliente');
    }
  }

  closeSocket() {
    if (distanceBetween <= 50 && socket.connected) {
      socket.disconnect(); // CERRAMOS EL SOCKET
    }
  }
}