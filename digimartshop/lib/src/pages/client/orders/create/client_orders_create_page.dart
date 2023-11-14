import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/shopping_cart.dart';
import 'package:digimartbox/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:digimartbox/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOrdersCreatePage extends StatelessWidget {
  ClientOrdersCreatePage({Key? key}) : super(key: key);
  final ClientOrdersCreateController clientOrdersCreateController = Get.put(ClientOrdersCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(245, 245, 245, 1),
          height: 110,
          child: _totalToPay(context),
        ),
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: const Text(
              'Carrito de compras',
              style: TextStyle(
                color: Colors.white,
              ),
            )
        ),
        body: clientOrdersCreateController.selectedProduct.isNotEmpty
            ? Container(
            color: Constants.colorGreyBackground,
              child: ListView(
          children: clientOrdersCreateController.selectedProduct.map((ShoppingCart prod) {
              return _cardProduct(context, prod);
          }).toList(),
        ),
            )
            : NoDataWidget(textMessage: 'No tienes productos en tu carrito.')
    ));
  }

  Widget _cardProduct(BuildContext context, ShoppingCart product) {
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
          _imageProduct(product),
          const SizedBox(width: 5),
          SizedBox(
            // width: 200,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nameProduct,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 7),
                _buttonsAddOrRemove(product),
              ],
            ),
          ),
          // const Spacer(), // Ocupa el resto de la pantalla que sobra y enviar lo que sigue al final de la pantalla
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _textPrice(product),
              _iconDelete(product),
            ],
          )
        ],
      ),
    );
  }

  Widget _imageProduct(ShoppingCart product) {
    return Container(
      height: 70,
      width: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FadeInImage(
          image: NetworkImage(product.imageProduct),
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder: const AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _buttonsAddOrRemove(ShoppingCart product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => clientOrdersCreateController.removeItem(product),
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
          child: Text('${product.quantity}'),
        ),
        GestureDetector(
          onTap: () => clientOrdersCreateController.addItem(product),
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

  Widget _iconDelete(ShoppingCart product) {
    return IconButton(
        onPressed: () => clientOrdersCreateController.deleteItem(product),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        )
    );
  }

  Widget _textPrice(ShoppingCart product) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        'L. ${(product.price * product.quantity).toStringAsFixed(2)}',
        style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
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
                    'L. ${clientOrdersCreateController.total.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                child: ElevatedButton(
                    onPressed: () => clientOrdersCreateController.goToNextPage(),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)
                    ),
                    child: const Text(
                      'CONFIRMAR ORDEN',
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
}
