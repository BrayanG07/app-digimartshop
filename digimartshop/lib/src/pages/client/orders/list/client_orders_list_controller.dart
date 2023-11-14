import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_list_user.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:get/get.dart';

class ClientOrdersListController extends GetxController {

  List<String> listStatus = <String>['ACTUAL', 'HISTORIAL'];
  OrderProvider orderProvider = OrderProvider();
  final RxInt selectedTabIndex = 0.obs;

  String getQuantityProducts(OrderListUser order) {
    int quantityProducts = 0;

    for (var element in order.orderDetail) {
      quantityProducts += element.quantity;
    }

    return quantityProducts.toString();
  }

  Future<List<OrderListUser>> getOrderByStatus (String status) async {
    return await orderProvider.getOrdersByStatus(status);
  }

  void goToOrderDetail (OrderListUser order) {
    Get.toNamed(ConfigRoute.keyClientOrderDetail, arguments: {
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
