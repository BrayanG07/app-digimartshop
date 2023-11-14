import 'dart:io';

import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:digimartbox/src/utils/manage_error.dart';
import 'package:digimartbox/src/models/ubication/ubication.dart';
import 'package:digimartbox/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:digimartbox/src/pages/client/address/map/client_address_map_page.dart';
import 'package:digimartbox/src/providers/ubication_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressClientController extends GetxController {
  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController refPointController = TextEditingController();

  double latitudeRedPoint = 0;
  double longitudeRedPoint = 0;

  UbicationProvider ubicationProvider = UbicationProvider();

  ClientAddressListController clientAddressListController = Get.find();

  void openGoogleMaps(BuildContext context) async {
    Map<String, dynamic> refPointMap = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientAddressMapPage(),
        // PARA QUE EL MODAL NO SE CIERRE CUANDO NOS ARRASTREMOS POR EL MAPA
        isDismissible: false,
        enableDrag: false,
    );

    refPointController.text = refPointMap['address'];
    latitudeRedPoint = refPointMap['latitude'];
    longitudeRedPoint = refPointMap['longitude'];
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;
    String refPoint = refPointController.text;
    String response = isValidForm(addressName, neighborhood, refPoint);

    if (response != 'OK') {
      AlertHandler.getAlertWarning(response);
      return;
    }
    
    Ubication ubication = Ubication(
        address: addressName,
        neighborhood: neighborhood,
        refPoint: refPoint,
        latitude: latitudeRedPoint.toString(),
        longitude: longitudeRedPoint.toString(),
        idUser: ''
    );

    Response responseApi = await ubicationProvider.create(ubication);
    if (responseApi.statusCode == HttpStatus.created) {
      Map<String, dynamic> ubicationToCreate = responseApi.body[Constants.responseApiData];

      Fluttertoast.showToast(msg: 'Direccion creada correctamente.', toastLength: Toast.LENGTH_LONG);
      ubication.idUbication = ubicationToCreate['idUbication'] ?? '';
      GetStorage().write(Constants.storageAddress, ubication.toJson());
      clientAddressListController.update(); // ACTUALIZAR LA PAGINA AL CREAR UNA UBICACION
      Get.back();
    }

    _evaluateResponseApi(responseApi);
  }

  String isValidForm(
      String addressName,
      String neighborhood,
      String refPoint,
      ) {
    if (addressName.isEmpty) return 'El nombre de la direccion no debe estar vacía.';
    if (neighborhood.isEmpty) return 'La calle no debe estar vacía.';
    if (refPoint.isEmpty) return 'El punto de referencia no debe no debe estar vacía.';
    if (latitudeRedPoint == 0) return 'Selecciona el punto de referencia en el mapa.';
    if (longitudeRedPoint == 0) return 'Selecciona el punto de referencia en el mapa.';

    return 'OK';
  }

  void _evaluateResponseApi(Response response) {
    if (response.statusCode == HttpStatus.unauthorized) {
      Fluttertoast.showToast(msg: 'La session ha expirado.', toastLength: Toast.LENGTH_LONG);
    }
    if (response.statusCode != HttpStatus.created) {
      String messageError = ManageError.getErrorMessage(response);
      AlertHandler.getAlertWarning(messageError);
    }
  }
}