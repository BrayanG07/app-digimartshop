import 'dart:io';

import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_detail.dart';
import 'package:digimartbox/src/models/order/order_list_delivery.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryOrdersDetailController extends GetxController {
  OrderListDelivery order = OrderListDelivery.fromJson(Get.arguments['order']);
  OrderProvider orderProvider = OrderProvider();
  RxString textButton = ''.obs;

  DeliveryOrdersDetailController() {
    print('ENTRANDO A CONSTRUCTOR DEL DETALLE DE ORDEN');
  }

  List<OrderDetail> getOrderDetail() {
    return order.orderDetail;
  }

  String getFullNameDelivery() {
    return '${order.user.firstName} ${order.user.lastName}';
  }

  String getNumberPhoneDelivery() {
    return order.user.phone ?? '';
  }

  void openGoogleMaps() async {
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=current+location&destination=${double.parse(order.latitude)},${double.parse(order.longitude)}&travelmode=driving";
    await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
  }

  void getTextButtonByStatus() {
    if (order.status == Constants.statusOrderSend) textButton.value = 'VOLVER AL MAPA';
    if (order.status == Constants.statusOrderPreparing) textButton.value = 'INICIAR ENTREGA';
  }

}