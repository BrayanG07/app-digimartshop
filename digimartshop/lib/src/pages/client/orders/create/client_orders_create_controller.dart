import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/shopping_cart.dart';
import 'package:digimartbox/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientOrdersCreateController extends GetxController {
  String idSupermarketUser = GetStorage().read(Constants.storageSupermarketUser);
  ClientProductsListController productsListController = Get.find(); // INSTANCIANDO UN CONTROLADOR EN OTRO CONTROLADO
  List<ShoppingCart> selectedProduct = <ShoppingCart>[].obs;
  var total = 0.0.obs;

  ClientOrdersCreateController() {
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

  void goToNextPage() {
    if (selectedProduct.isEmpty) {
      AlertHandler.getAlertWarning('Carrito de compras vacio.');
    } else {
      Get.toNamed(ConfigRoute.keySelectAddress, arguments: {
        'totalPay': total.value
      });
    }
  }

  void _modifyQuantityProduct() {
    productsListController.quantityProducts.value = 0;
    for (var element in selectedProduct) {
      productsListController.quantityProducts.value =
          productsListController.quantityProducts.value + element.quantity;
    }
  }

}