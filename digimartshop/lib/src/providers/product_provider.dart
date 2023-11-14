import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/product/product.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/models/category/category.dart';
import 'package:digimartbox/src/environment/environment.dart';

class ProductProvider extends GetConnect {
  User userSession = User.fromJson(GetStorage().read(Constants.storageUserSession) ?? {});

  Future<List<Category>> listAllCategories() async {
    Response response = await get(
        Environment.urlProduct,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    List<Category> categories = Category.fromJsonList(response.body);

    return categories;
  }

  Future<List<Product>> findProductsBySupermarketAndCategory(String idCategory) async {
    String idSupermarket = GetStorage().read(Constants.storageSupermarketUser);

    Response response = await get(
        '${Environment.urlProduct}/supermarket/$idSupermarket/$idCategory',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    List<Product> values = Product.fromJsonList(response.body);

    return values;
  }

}