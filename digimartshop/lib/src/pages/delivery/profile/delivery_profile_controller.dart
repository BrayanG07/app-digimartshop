import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeliveryProfileController extends GetxController {

  var user = User.fromJson(GetStorage().read(Constants.storageUserSession)).obs;

  void signOut() {
    GetStorage().remove(Constants.storageUserSession);
    Get.offNamedUntil(ConfigRoute.keyLogin, (route) => false); // ELIMINA EL HISTORIAL O LA COLA DE PANTALLAS
  }
}