import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/create_order.dart';
import 'package:digimartbox/src/models/order/order_list_delivery.dart';
import 'package:digimartbox/src/models/order/order_list_user.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/environment/environment.dart';

class OrderProvider extends GetConnect {
  User userSession = User.fromJson(GetStorage().read(Constants.storageUserSession) ?? {});

  Future<Response> create(CreateOrder createOrder) async {
    Response response = await post(
        Environment.urlOrder,
        createOrder.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    return response;
  }

  Future<List<OrderListUser>> getOrdersByStatus(String status) async {
    String route = status == 'ACTUAL' ? 'all-orders-pending/${userSession.idUser}' : 'all-orders/${userSession.idUser}/ENTREGADO';
    Response response = await get(
        '${Environment.urlOrder}/$route',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    List<OrderListUser> values = OrderListUser.fromJsonList(response.body);

    return values;
  }

  Future<List<OrderListDelivery>> getOrdersDeliveryByStatus(String status) async {
    String route = status == 'ACTUAL' ? 'delivered' : 'completed';
    Response response = await get(
        '${Environment.urlOrder}/$route/${userSession.idUser}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    List<OrderListDelivery> values = OrderListDelivery.fromJsonList(response.body);

    return values;
  }

  Future<Response> changeOrderToSend(String idOrder) async {
    Response response = await get(
        '${Environment.urlOrder}/send/$idOrder',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    return response;
  }

  Future<Response> changeOrderToEnd(String idOrder) async {
    return await get(
        '${Environment.urlOrder}/end-orden/$idOrder',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );
  }

  Future<void> updateLocationDelivery(double latitude, double longitude) async {
    Response response = await patch(
        '${Environment.urlUser}/location-delivery/${userSession.idUser}',{
          'latitude': latitude,
          'longitude': longitude,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    if (response.statusCode != 200) {
      AlertHandler.getAlertWarning('Se produjo un error al actualizar su ubicación.');
    }
  }
}