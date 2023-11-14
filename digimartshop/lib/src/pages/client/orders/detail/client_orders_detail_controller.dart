import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_detail.dart';
import 'package:digimartbox/src/models/order/order_list_user.dart';
import 'package:get/get.dart';

class ClientOrdersDetailController {
  OrderListUser order = OrderListUser.fromJson(Get.arguments['order']);

  List<OrderDetail> getOrderDetail() {
    return order.orderDetail;
  }

  String getFullNameDelivery() {
    String fullName = 'Sin Asignar';
    if (order.userDelivery != null) {
      fullName = '${order.userDelivery?.user.firstName} ${order.userDelivery?.user.lastName}';
    }

    return fullName;
  }

  String getNumberPhoneDelivery() {
    return order.userDelivery?.user.phone ?? '';
  }

  void goToOrderMap() {
    if(order.status == Constants.statusOrderSend) {
      Get.toNamed(ConfigRoute.keyClientOrderMap, arguments: { 'order': order.toJson() });
    }
  }

}