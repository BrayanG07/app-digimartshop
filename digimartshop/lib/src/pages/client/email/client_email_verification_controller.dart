import 'dart:io';

import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:digimartbox/src/utils/manage_error.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientEmailVerificationController extends GetxController {
  UserProvider userProvider = UserProvider();

  TextEditingController codeOne = TextEditingController();
  TextEditingController codeTwo = TextEditingController();
  TextEditingController codeThree = TextEditingController();
  TextEditingController codeFour = TextEditingController();

  User user = User.fromJson(Get.arguments['user']);
  File? imageFile = Get.arguments['imageFile'];
  String codeEmail = Get.arguments['codeEmail'];

  void validateCodeVerification(BuildContext context) async {
    String codeUser = '${codeOne.text}${codeTwo.text}${codeThree.text}${codeFour.text}';
    if (codeUser != codeEmail) {
      AlertHandler.getAlertWarning('Código de verificación incorrecto.');
      return;
    }

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Creando usuario...' );

    Response response = await userProvider.create(user);
    progressDialog.close();

    if (response.statusCode != HttpStatus.created) {
      String messageError = ManageError.getErrorMessage(response);
      AlertHandler.getAlertWarning(messageError);
      return;
    }

    GetStorage().write(Constants.storageUserSession, response.body[Constants.responseApiData]); // ALMACENAMOS LOS DATOS EN SESION
    Get.offNamedUntil(ConfigRoute.keyDepartment, (route) => false);
  }
}