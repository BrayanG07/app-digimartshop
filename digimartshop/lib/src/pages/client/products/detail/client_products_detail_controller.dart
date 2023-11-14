import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/shopping_cart.dart';
import 'package:digimartbox/src/models/product/product.dart';
import 'package:digimartbox/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductsDetailController extends GetxController {

  List<ShoppingCart> selectedProductCart = [];
  ClientProductsListController productsListController = Get.find(); // INSTANCIANDO UN CONTROLADOR EN OTRO CONTROLADO
  String idSupermarketUser = GetStorage().read(Constants.storageSupermarketUser);

  ClientProductsDetailController();

  void checkIfProductsWasAdded(Product product, var price, var counter) {
    price.value = double.parse(product.price);

    // OBTENER LOS PRODUCTOS SI YA EXISTEN EN LA SESION PARA RECORDARSELOS AL USUARIO
    if (GetStorage().read(Constants.storageShoppingBag) != null) {
      if (GetStorage().read(Constants.storageShoppingBag) is List<ShoppingCart>) {
        selectedProductCart = GetStorage().read(Constants.storageShoppingBag);
      } else {
        selectedProductCart = ShoppingCart.fromJsonList(GetStorage().read(Constants.storageShoppingBag));
      }

      int index = selectedProductCart.indexWhere((element) => element.idProduct == product.idProduct);
      if (index != -1) { // EL PRODUCTO YA FUE AGREGADO
        counter.value = selectedProductCart[index].quantity;
        price.value = double.parse(product.price) * counter.value;
      }
    }
  }

  void _modifyQuantityProduct() {
    productsListController.quantityProducts.value = 0;
    for (var element in selectedProductCart) {
      productsListController.quantityProducts.value =
          productsListController.quantityProducts.value + element.quantity;
    }
  }

  void addItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = double.parse(product.price) * counter.value;
    Fluttertoast.showToast(msg: 'Producto agregado');

    // Buscamos el producto entre la lista de productos
    int index = selectedProductCart.indexWhere((element) => element.idProduct == product.idProduct);
    // PRODUCTO AUN NO AGREGADO
    if (index == -1) {
      if (product.quantity == null) {
        if (counter.value > 0) {
          product.quantity = counter.value;
        } else {
          product.quantity = 1;
        }
      }

      selectedProductCart.add(_prepareShoppingCart(product));
    } else { // EL PRODUCTO YA HA SIDO AGREGAGO EN STORAGE
      selectedProductCart[index].quantity = counter.value; // MODIFICAMOS LA CANTIDAD SELECCIONADA POR EL USUARIO.
    }

    GetStorage().write(Constants.storageShoppingBag, selectedProductCart);
    _modifyQuantityProduct();
  }

  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
      price.value = double.parse(product.price) * counter.value;
      Fluttertoast.showToast(msg: 'Producto removido');

      // BUSCAMOS EL PRODUCTO EN LA LISTA DE PRODUCTOS
      int index = selectedProductCart.indexWhere((element) => element.idProduct == product.idProduct);

      if (counter.value == 0) {
        selectedProductCart.remove(selectedProductCart[index]);
      } else if (counter.value > 0) {
        selectedProductCart[index].quantity = counter.value;
      }

      GetStorage().write(Constants.storageShoppingBag, selectedProductCart);
      if (selectedProductCart.isEmpty) {
        productsListController.quantityProducts.value = 0;
      } else {
        _modifyQuantityProduct();
      }
    }
  }

  ShoppingCart _prepareShoppingCart(Product product) {
    ShoppingCart shoppingCart = ShoppingCart(
        idProduct: product.idProduct,
        idStock: product.stock[0].idStock,
        idSupermarket: idSupermarketUser,
        nameProduct: product.name,
        imageProduct: product.image,
        descriptionProduct: product.description,
        quantity: product.quantity ?? 0,
        price: double.parse(product.price)
    );

    return shoppingCart;
  }

}