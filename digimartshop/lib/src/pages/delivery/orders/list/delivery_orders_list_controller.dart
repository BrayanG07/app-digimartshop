import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_list_delivery.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:get/get.dart';

class DeliveryOrdersListController extends GetxController {

  OrderProvider orderProvider = OrderProvider();
  List<String> listStatus = <String>['ACTUAL', 'HISTORIAL'];
  List<OrderListDelivery> listOrders = <OrderListDelivery>[].obs;
  RxBool isLoading = true.obs;
  RxBool tabStatus = true.obs;

  String getQuantityProducts(OrderListDelivery order) {
    int quantityProducts = 0;

    for (var element in order.orderDetail) {
      quantityProducts += element.quantity;
    }

    return quantityProducts.toString();
  }

  Future<void> getOrderByStatus () async {
    try {
      isLoading(true);
      var result = await orderProvider.getOrdersDeliveryByStatus('ACTUAL');
      listOrders.clear();
      listOrders.addAll(result);
    } catch (e) {
      AlertHandler.getAlertWarning(e.toString());
      throw Exception(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void goToOrderDetail (OrderListDelivery order) {
    Get.toNamed(ConfigRoute.keyDeliveryOrderDetail, arguments: {
      'order': order.toJson()
    });
  }

  String getColorByStatus(String status) {
    String color = '';
    if (status == Constants.statusOrderDelivered) color = '#239B56';
    if (status == Constants.statusOrderSend) color = '#D68910';
    if (status == Constants.statusOrderPending) color = '#6C3483';
    if (status == Constants.statusOrderPreparing) color = '#D4AC0D';
    if (status == Constants.statusOrderCanceled) color = '#D32806';

    return color;
  }
}