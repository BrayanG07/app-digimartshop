import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/ubication/ubication.dart';
import 'package:digimartbox/src/providers/ubication_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressListController extends GetxController {
  List<Ubication> address = [];
  UbicationProvider addressProvider = UbicationProvider();

  var radioValue = 0.obs;

  Future<List<Ubication>> getAddress() async {
    address = await addressProvider.listUbicationByIdUser();

    return address;
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    GetStorage().write(Constants.storageAddress, address[value].toJson());
    update();
  }

  void goToAddressCreate() {
    Get.toNamed(ConfigRoute.keyClientAddressCreate);
  }
}