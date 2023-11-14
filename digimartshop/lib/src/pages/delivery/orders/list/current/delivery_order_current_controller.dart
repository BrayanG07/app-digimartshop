import 'dart:io';

import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_list_delivery.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:digimartbox/src/utils/manage_error.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class DeliveryOrderCurrentController extends GetxController {
  OrderProvider orderProvider = OrderProvider();
  RxList<OrderListDelivery> listOrders = <OrderListDelivery>[].obs;
  RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getCurrentOrders();
  }

  Future<void> getCurrentOrders() async {
    try {
      isLoading(true);
      var result = await orderProvider.getOrdersDeliveryByStatus('ACTUAL');
      listOrders.addAll(result);
    } catch (e) {
      AlertHandler.getAlertWarning(e.toString());
      throw Exception(e.toString());
    } finally {
      print('LISTADO CURRENT');
      isLoading(false);
    }
  }

  String getQuantityProducts(OrderListDelivery order) {
    int quantityProducts = 0;

    for (var element in order.orderDetail) {
      quantityProducts += element.quantity;
    }

    return quantityProducts.toString();
  }

  HexColor getColorByStatus(String status) {
    String color = '';
    if (status == Constants.statusOrderSend) color = '#D68910';
    if (status == Constants.statusOrderPending) color = '#6C3483';
    if (status == Constants.statusOrderPreparing) color = '#D4AC0D';
    if (status == Constants.statusOrderCanceled) color = '#D32806';

    return HexColor(color);
  }

  void goToOrderDetail (OrderListDelivery order) {
    Get.toNamed(ConfigRoute.keyDeliveryOrderDetail, arguments: {
      'order': order.toJson()
    });
  }

  Future<void> executeButtonOrder(OrderListDelivery order) async {
    if (order.status == Constants.statusOrderSend) {
      Get.toNamed(ConfigRoute.keyDeliveryOrderMap, arguments: { 'order': order.toJson() });
    } else if (order.status == Constants.statusOrderPreparing) {
      Response response = await orderProvider.changeOrderToSend(order.idOrder);

      if (response.statusCode != HttpStatus.ok) {
        _evaluateResponseApi(response);
      } else {
        _updateStatusListOrders(order);
      }
    }
  }

  void _updateStatusListOrders(OrderListDelivery order) {
    int index = listOrders.indexWhere((item) => item.idOrder == order.idOrder);
    if (index != -1) {
      order.buttonText = 'VOLVER AL MAPA';
      order.status = Constants.statusOrderSend;
      listOrders.removeAt(index);
      listOrders.insert(index, order);

      Get.toNamed(ConfigRoute.keyDeliveryOrderMap, arguments: { 'order': order.toJson() });
    }
  }

  void _evaluateResponseApi(Response response) {
    if (response.statusCode == HttpStatus.unauthorized) {
      Fluttertoast.showToast(msg: 'La session ha expirado.', toastLength: Toast.LENGTH_LONG);
    }
    if (response.statusCode != HttpStatus.ok) {
      String messageError = ManageError.getErrorMessage(response);
      AlertHandler.getAlertWarning(messageError);
    }
  }
}