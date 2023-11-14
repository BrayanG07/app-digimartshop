import 'package:digimartbox/src/config/config_route.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientHomeController extends GetxController {
  var indexTab = 0.obs;

  void changeTab(int index) {
    indexTab.value = index;
    update();
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil(ConfigRoute.keyLogin, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

}