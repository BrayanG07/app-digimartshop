import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_list_delivery.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class DeliveryOrderHistoryController extends GetxController {
  OrderProvider orderProvider = OrderProvider();
  List<OrderListDelivery> listOrders = <OrderListDelivery>[].obs;
  RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getHistoryOrders();
  }

  Future<void> getHistoryOrders() async {
    try {
      isLoading(true);
      var result = await orderProvider.getOrdersDeliveryByStatus('HISTORIAL');
      listOrders.addAll(result);
    } catch (e) {
      AlertHandler.getAlertWarning(e.toString());
      throw Exception(e.toString());
    } finally {
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

  void goToOrderDetail (OrderListDelivery order) {
    Get.toNamed(ConfigRoute.keyDeliveryOrderDetail, arguments: {
      'order': order.toJson()
    });
  }
}