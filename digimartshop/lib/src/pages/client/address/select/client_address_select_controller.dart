import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/ubication/ubication.dart';
import 'package:digimartbox/src/providers/ubication_provider.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressSelectController extends GetxController {
  double totalPay = Get.arguments['totalPay'];
  List<Ubication> address = [];
  UbicationProvider addressProvider = UbicationProvider();
  var radioValue = 0.obs;

  Future<List<Ubication>> getAddress() async {
    address = await addressProvider.listUbicationByIdUser();

    if (GetStorage().read(Constants.storageAddress) != null) {
      Ubication a = Ubication.fromJson(GetStorage().read(Constants.storageAddress)) ; // DIRECCION SELECCIONADA POR EL USUARIO
      int index = address.indexWhere((ad) => ad.idUbication == a.idUbication);

      if (index != -1) { // LA DIRECCION DE SESION COINCIDE CON UN DATOS DE LA LISTA DE DIRECCIONES
        radioValue.value = index;
      }
    } else {
      if (address.isNotEmpty) {
        GetStorage().write(Constants.storageAddress, address[0].toJson());
      }
    }

    return address;
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    GetStorage().write(Constants.storageAddress, address[value].toJson());
    update();
  }

  void goToNextPage() {
    if (address.isEmpty) {
      AlertHandler.getAlertWarning('Debes crear una ubicacion');
    } else {
      Get.toNamed(ConfigRoute.keyClientSelectPaymentType, arguments: {
        'totalPay': totalPay
      });
    }
  }

}