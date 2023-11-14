import 'dart:io';

import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:digimartbox/src/utils/manage_error.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:digimartbox/src/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfileUpdateController extends GetxController {
  User user = User.fromJson(GetStorage().read(Constants.storageUserSession));

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dniController = TextEditingController();

  UserProvider userProvider = UserProvider();
  ImagePicker picker = ImagePicker();
  File? imageFile;

  // find() = Accedemos a todos los metodos y atributos que tenga ese controller
  ClientProfileInfoController clientProfileInfoController =  Get.find();

  ClientProfileUpdateController() {
    nameController.text = user.firstName ?? '';
    lastnameController.text = user.lastName ?? '';
    phoneController.text = user.phone ?? '';
    dniController.text = user.dni ?? '';
  }

  void updateUser(BuildContext context) async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    String dni = dniController.text;

    String response = isValidForm(name, lastname, phone);

    if (response != 'OK') {
      AlertHandler.getAlertWarning(response);
      return;
    }

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Actualizando datos.');

    User userToUpdated = User(idUser: user.idUser, firstName: name, lastName: lastname, phone: phone, dni: dni);

    Response responseApi = await userProvider.update(userToUpdated, imageFile);
    progressDialog.close();

    if (responseApi.statusCode == HttpStatus.ok) {
      Map<String, dynamic> userToLogin = responseApi.body[Constants.responseApiData];
      userToLogin['token'] = user.token;

      AlertHandler.getAlertSuccess('Datos actualizados correctamente.');

      // ALMACENAMOS LOS DATOS ACTUALZIADOS EN SESION
      GetStorage().write(Constants.storageUserSession, responseApi.body[Constants.responseApiData]);
      clientProfileInfoController.user.value = User.fromJson(GetStorage().read(Constants.storageUserSession) ?? {});
    } else {
      String messageError = ManageError.getErrorMessage(responseApi);
      AlertHandler.getAlertWarning(messageError);
    }
  }

  String isValidForm(
      String name,
      String lastname,
      String phone
      ) {
    if (name.isEmpty) return 'El nombre no debe estar vacío.';
    if (lastname.isEmpty) return 'El apellido no debe estar vacío.';
    if (phone.isEmpty) return 'El numero de telefono no debe estar vacío.';
    return 'OK';
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update(); // Para actualizar la imagen y refrescar el Widget
    }
  }

  void showAlertDialog(BuildContext buildContext) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: const Text(
          'GALERIA',
          style: TextStyle(
            color: Colors.white,
          ),
        )
    );
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: const Text(
            'CAMARA',
            style: TextStyle(
              color: Colors.white,
            )
        )
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text(
        'Selecciona una opcion.',
        style: TextStyle(
          color: Colors.black
        ),
      ), actions: [
        galleryButton, cameraButton
      ],
    );

    showDialog(context: buildContext, builder: (BuildContext context) {
      return  alertDialog;
    });

  }
}