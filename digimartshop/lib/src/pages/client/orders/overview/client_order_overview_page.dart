import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/shopping_cart.dart';
import 'package:digimartbox/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:digimartbox/src/pages/client/orders/overview/client_order_overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientOrderOverviewPage extends StatelessWidget {
  ClientOrderOverviewPage({Key? key}) : super(key: key);
  final ClientOrderOverviewController controller = Get.put(ClientOrderOverviewController());
  final ClientAddressListController addressController = Get.put(ClientAddressListController());


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Color.fromRGBO(243, 243, 243, 2),
          ),
          height: MediaQuery.of(context).size.height * 0.26,
          child: Column(
            children: [
              _dataAddress(),
              _totalToPay(context),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Resumen',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        body:  ListView(
          children: controller.selectedProduct.map((ShoppingCart shoppingCart) {
            return _cardProduct(context, shoppingCart);
          }).toList(),
        ),
    )) ;
  }

  Widget _dataAddress() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: ListTile(
          leading: Icon(
            Icons.location_on,
            color: Constants.colorPrimary,
            size: 30,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.ubicationSession.address,
                style:  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                controller.ubicationSession.refPoint,
                maxLines: 2,
                style:  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.check,
            color: Colors.green,
            size: 30,
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _cardProduct(BuildContext context, ShoppingCart shoppingCart) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 1), // Desplazamiento en horizontal y vertical
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          _imageProduct(shoppingCart),
          const SizedBox(width: 5),
          Container(
            // width: 200,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shoppingCart.nameProduct,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 7),
                _buttonsAddOrRemove(shoppingCart),
              ],
            ),
          ),
          // const Spacer(), // Ocupa el resto de la pantalla que sobra y enviar lo que sigue al final de la pantalla
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _textPrice(shoppingCart),
              _iconDelete(shoppingCart),
            ],
          )
        ],
      ),
    );
  }

  Widget _imageProduct(ShoppingCart shoppingCart) {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: shoppingCart.imageProduct.isNotEmpty
              ? NetworkImage(shoppingCart.imageProduct)
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
          padding: const EdgeInsets.all(10),
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
                    'L. ${controller.total.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
                child: ElevatedButton(
                    onPressed: () => controller.createOrder(),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)
                    ),
                    child: const Text(
                      'FINALIZAR COMPRA',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
              )
            ],
          ),
        )

      ],
    );
  }

  Widget _buttonsAddOrRemove(ShoppingCart shoppingCart) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => controller.removeItem(shoppingCart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
            ),

            child: const Text('-'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text('${shoppingCart.quantity}'),
        ),
        GestureDetector(
          onTap: () => controller.addItem(shoppingCart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )
            ),
            child: const Text('+'),
          ),
        ),
      ],
    );
  }

  Widget _iconDelete(ShoppingCart shoppingCart) {
    return IconButton(
        onPressed: () => controller.deleteItem(shoppingCart),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        )
    );
  }

  Widget _textPrice(ShoppingCart shoppingCart) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        'L. ${(shoppingCart.price * shoppingCart.quantity).toStringAsFixed(2)}',
        style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
