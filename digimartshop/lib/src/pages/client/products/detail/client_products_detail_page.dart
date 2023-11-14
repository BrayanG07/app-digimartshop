import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/product/product.dart';
import 'package:digimartbox/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientProductsDetailPage extends StatelessWidget {
  Product? product;
  // late =  con esto le decimos que esta variable se inicializara mas adelante
  late ClientProductsDetailController clientProductsDetailController;
  var counter = 0.obs;
  var price = 0.0.obs;

  ClientProductsDetailPage({ required this.product }) {
    clientProductsDetailController = Get.put(ClientProductsDetailController());
  }

  @override
  Widget build(BuildContext context) {
    clientProductsDetailController.checkIfProductsWasAdded(product!, price, counter);

    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1.0),
            height: 100,
            child: _buttonsAddToBag()
        ),
        body: Column(
          children: [
            _imageSlideShow(context),
            _textNameProduct(),
            _textDescriptionProduct(),
            _textPriceProduct(),
          ],
        )
    ));
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Text(
        product!.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black
        ),
      ),
    );
  }

  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
      child: Text(
        product!.description,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _textPriceProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
      child: Text(
        'L. ${product!.price.toString()}',
        style: const TextStyle(
          fontSize: 19,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buttonsAddToBag() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => clientProductsDetailController.removeItem(product!, price, counter),
                child: Text(
                  '-',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: const Size(45, 37),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        )
                    )
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  '${counter.value}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: const Size(40, 37)
                ),
              ),
              ElevatedButton(
                onPressed: () => clientProductsDetailController.addItem(product!, price, counter),
                child: Text(
                  '+',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: const Size(45, 37),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        )
                    )
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => () {},
                child: Text(
                  'L. ${price.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Constants.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                    )
                ),
              ),
            ],
          ),
        )

      ],
    );
  }

  Widget _imageSlideShow(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            ImageSlideshow(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                initialPage: 0,
                children: [
                  FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: const AssetImage('assets/img/no-image.png'),
                      image: NetworkImage(product!.image)
                  )
                ]
            )
          ],
        )
    );
  }
}
