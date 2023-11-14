import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_detail.dart';
import 'package:digimartbox/src/pages/client/orders/detail/client_orders_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOrdersDetailPage extends StatelessWidget {

  ClientOrdersDetailPage({Key? key}) : super(key: key);
  final ClientOrdersDetailController con = Get.put(ClientOrdersDetailController());


  @override
  Widget build(BuildContext context) {
    double heightFooter = con.order.status == Constants.statusOrderDelivered ? 0.34 : 0.39;
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Color.fromRGBO(243, 243, 243, 2),
          ),
          height: MediaQuery.of(context).size.height * heightFooter,
          child: Column(
            children: [
              _dataAddress(),
              _dataDate(),
              _dataDelivery(),
              _totalToPay(context),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Detalle de orden',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 5),
          child: ListView(
            children: con.getOrderDetail().map((OrderDetail order) {
              return _cardProduct(context, order);
            }).toList(),
          ),
        )
    );
  }

  Widget _dataDelivery() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: const Text(
          'Repartidor',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('${con.getFullNameDelivery()} ${con.getNumberPhoneDelivery()}'),
         trailing: _widgetDelivery(),
      ),
    );
  }

  Widget _dataAddress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: const Text(
          'Dirección de entrega',
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        subtitle: Text(con.order.address),
        trailing: Icon(
          Icons.location_on,
          color: Constants.colorPrimary
        ),
      ),
    );
  }

  Widget _widgetDelivery() {
    if (con.order.userDelivery != null && con.order.status != Constants.statusOrderDelivered) {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          'LLAMAR',
          style: TextStyle( color: Colors.white ),
        ),
      );
    }

    return Icon(
      Icons.delivery_dining,
      color: Constants.colorPrimary,
    );
  }

  Widget _dataDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: const Text('Fecha del pedido', style: TextStyle(
            fontWeight: FontWeight.w500
        )),
        subtitle: Text(con.order.createdAt.toString().split('.')[0]),
        trailing: Icon(
          Icons.timer,
          color: Constants.colorPrimary,
        ),
      ),
    );
  }

  Widget _cardProduct(BuildContext context, OrderDetail order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      padding: const EdgeInsets.all(10),
      decoration:  BoxDecoration(
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
      child: Row(
        children: [
          _imageProduct(order),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  order.nameProduct,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87
                  ),
                ),
                Text(
                  'L. ${order.priceProduct} - Cantidad: ${order.quantity} ',
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
    );
  }

  Widget _imageProduct(OrderDetail order) {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: order.imageProduct.isNotEmpty
              ? NetworkImage(order.imageProduct)
              : const AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder:  const AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                  Text(
                    'L. ${con.order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ],
              ),
              con.order.status == Constants.statusOrderDelivered ?
              Container() : Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
                child: ElevatedButton(
                    onPressed: () => con.goToOrderMap(),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)
                    ),
                    child: const Text(
                      'RASTREAR PEDIDO',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
              ),
            ],
          ),
        )

      ],
    );
  }
}
