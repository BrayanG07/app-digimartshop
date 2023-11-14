import 'dart:io';

import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/card_payment.dart';
import 'package:digimartbox/src/models/order/create_order.dart';
import 'package:digimartbox/src/models/order/shopping_cart.dart';
import 'package:digimartbox/src/models/ubication/ubication.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:digimartbox/src/providers/order_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:digimartbox/src/utils/manage_error.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientOrderOverviewController extends GetxController {
  ClientProductsListController productsListController = Get.find();
  List<ShoppingCart> selectedProduct = <ShoppingCart>[].obs;
  var total = 0.0.obs;
  String typePayment = Get.arguments['typePayment'] ?? '';
  double amountToPay = Get.arguments['amountToPay'] ?? 0.0;
  CardPayment? cardPayment = Get.arguments['cardPayment'] != null ? CardPayment.fromJson(Get.arguments['cardPayment']) : null;
  late Ubication ubicationSession;

  OrderProvider orderProvider = OrderProvider();

  ClientOrderOverviewController() {
    _loadShoppingCart();
    _loadUbication();
  }

  void getTotal() {
    total.value = 0.0;
    for (var item in selectedProduct) {
      total.value = total.value + (item.quantity * item.price);
    }
  }

  void addItem(ShoppingCart shoppingCart) {
    int index = selectedProduct.indexWhere((element) => element.idProduct == shoppingCart.idProduct);
    selectedProduct.remove(shoppingCart);
    shoppingCart.quantity = shoppingCart.quantity + 1;
    selectedProduct.insert(index, shoppingCart);
    GetStorage().write(Constants.storageShoppingBag, selectedProduct);
    getTotal();
    _modifyQuantityProduct();
  }

  void removeItem(ShoppingCart shoppingCart) {
    if (shoppingCart.quantity > 1) {
      int index = selectedProduct.indexWhere((element) => element.idProduct == shoppingCart.idProduct);
      selectedProduct.remove(shoppingCart);
      shoppingCart.quantity = shoppingCart.quantity - 1;
      selectedProduct.insert(index, shoppingCart);
      GetStorage().write(Constants.storageShoppingBag, selectedProduct);
      getTotal();

      if (selectedProduct.isEmpty) {
        productsListController.quantityProducts.value = 0;
      } else {
        _modifyQuantityProduct();
      }
    }
  }

  void deleteItem(ShoppingCart shoppingCart) {
    selectedProduct.remove(shoppingCart);
    GetStorage().write(Constants.storageShoppingBag, selectedProduct);
    getTotal();

    if (selectedProduct.isEmpty) {
      productsListController.quantityProducts.value = 0;
    } else {
      _modifyQuantityProduct();
    }
  }

  void createOrder() async {
    User userSession = User.fromJson(GetStorage().read(Constants.storageUserSession));
    CreateOrder createOrder = CreateOrder(
        idUser: userSession.idUser!,
        paymentType: typePayment,
        cardName: cardPayment != null ? cardPayment!.cardName : null,
        cardNumber: cardPayment != null ? cardPayment!.cardNumber : null,
        cardCvv: cardPayment != null ? cardPayment!.cardCvv : null,
        monthCard: cardPayment != null ? cardPayment!.monthCard : null,
        yearCard: cardPayment != null ? cardPayment!.yearCard : null,
        email: cardPayment != null ? userSession.email : null,
        latitude: ubicationSession.latitude,
        longitude: ubicationSession.longitude,
        address: ubicationSession.address,
        addressDetail: ubicationSession.refPoint,
        moneyToPay: amountToPay,
        shoppingCart: selectedProduct,
        comment: 'Sin comentarios'
    );

    // PROCESAR LA ORDEN CON LA API_REST.
    Response responseApi = await orderProvider.create(createOrder);

    if (responseApi.statusCode == HttpStatus.unauthorized) {
      AlertHandler.getAlertWarning('La session ha expirado.');
    } else if (responseApi.statusCode != HttpStatus.created) {
      String messageError = ManageError.getErrorMessage(responseApi);
      AlertHandler.getAlertWarning(messageError);
    } else if (responseApi.statusCode == HttpStatus.created) {
      // BORRAR EL STORAGE DEL CARRITO DE COMPRAS.
      GetStorage().remove(Constants.storageShoppingBag);
      AlertHandler.getAlertSuccess('Compra realizada correctamente.');
      Get.offNamedUntil(ConfigRoute.keyClientHome, (route) => false);
    }
  }

  _loadShoppingCart() {
    if (GetStorage().read(Constants.storageShoppingBag) != null) {
      if (GetStorage().read(Constants.storageShoppingBag) is List<ShoppingCart>) {
        var result = GetStorage().read(Constants.storageShoppingBag);
        selectedProduct.clear();
        selectedProduct.addAll(result);
      } else {
        var result = ShoppingCart.fromJsonList(GetStorage().read(Constants.storageShoppingBag));
        selectedProduct.clear();
        selectedProduct.addAll(result);
      }

      getTotal();
    }
  }

  void _loadUbication() {
    ubicationSession = Ubication.fromJson(GetStorage().read(Constants.storageAddress));
  }

  void _modifyQuantityProduct() {
    productsListController.quantityProducts.value = 0;
    for (var element in selectedProduct) {
      productsListController.quantityProducts.value =
          productsListController.quantityProducts.value + element.quantity;
    }
  }

}