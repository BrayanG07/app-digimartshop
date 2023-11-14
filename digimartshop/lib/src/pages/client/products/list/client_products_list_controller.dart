import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/shopping_cart.dart';
import 'package:digimartbox/src/models/product/product.dart';
import 'package:digimartbox/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:digimartbox/src/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digimartbox/src/models/category/category.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController extends GetxController {
 ProductProvider productProvider = ProductProvider();

 List<ShoppingCart> selectedProductCart = [];
 RxInt quantityProducts = 0.obs;
 final RxInt selectedTabIndex = 0.obs;

 @override
 void onReady() {
   super.onReady();
   _loadQuantityProductsByCart();
 }

 void _loadQuantityProductsByCart() {
  if (GetStorage().read(Constants.storageShoppingBag) != null) {
   if (GetStorage().read(Constants.storageShoppingBag) is List<ShoppingCart>) {
    selectedProductCart = GetStorage().read(Constants.storageShoppingBag);
   } else {
    selectedProductCart = ShoppingCart.fromJsonList(GetStorage().read(Constants.storageShoppingBag));
   }

   _modifyQuantityProduct();
  }
 }

 void _modifyQuantityProduct() {
  quantityProducts.value = 0;
  for (var element in selectedProductCart) {
   quantityProducts.value = quantityProducts.value + element.quantity;
  }
 }

  Future<List<Category>> getCategories() async {
   return await productProvider.listAllCategories();
  }

  Future<List<Product>> getProducts(String idCategory) async {
    return await productProvider.findProductsBySupermarketAndCategory(idCategory);
  }

  void openBottomSheet(BuildContext context, Product product) {
   print('IMAGE ${product.image}');
    showMaterialModalBottomSheet(context: context, builder: (context) => ClientProductsDetailPage(product: product));
  }

  void goToOrderCreate() {
   Get.toNamed(ConfigRoute.keyClientOrderCreate);
  }

}