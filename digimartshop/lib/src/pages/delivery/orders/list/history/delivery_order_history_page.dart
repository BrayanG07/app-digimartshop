import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_list_delivery.dart';
import 'package:digimartbox/src/pages/delivery/orders/list/history/delivery_order_history_controller.dart';
import 'package:digimartbox/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOrderHistoryPage extends StatelessWidget {
  DeliveryOrderHistoryPage({Key? key}) : super(key: key);
  final DeliveryOrderHistoryController deliveryController = Get.put(DeliveryOrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.colorGreyBackground,
      child: ListView.builder(
          itemCount: deliveryController.listOrders.length,
          itemBuilder: (context, index) {
            if (deliveryController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (!deliveryController.isLoading.value && deliveryController.listOrders.isNotEmpty) {
              return _cardOrder(deliveryController.listOrders[index]);
            }

            // Agregar esta validación
            return NoDataWidget(textMessage: 'No hay ordenes.');
          }
      ),
    );
  }

  Widget _cardOrder(OrderListDelivery order) {
    return GestureDetector(
      onTap: () => deliveryController.goToOrderDetail(order),
      child: Column(
        children: [
          Container(
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 1), // Desplazamiento en horizontal y vertical
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      order.status.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                        height: 55,
                        width: 55,
                        margin: const EdgeInsets.only(right: 15),
                        child: Image.asset('assets/img/order_icon.png')
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            order.supermarket.name,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                            ),
                          ),
                          Text(
                            '#${order.idOrder.split('-')[0].toUpperCase()}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87
                            ),
                          ),
                          Text(
                            'L. ${order.total} - ${deliveryController.getQuantityProducts(order)} productos',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800]
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
