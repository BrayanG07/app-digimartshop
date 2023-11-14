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
import 'package:intl_phone_field/countries.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController emailSponsorController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UserProvider userProvider = UserProvider();

  var isSwitched = false.obs;
  var heightForm = 0.53.obs;
  var numberPhone = ''.obs;

  void register(BuildContext context) async {
    String email = emailController.text.split(' ').join('').toLowerCase();
    String emailSponsor = emailSponsorController.text.split(' ').join('').toLowerCase();
    String phone = numberPhone.value;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String response = isValidForm(email, emailSponsor, phone, password, confirmPassword);

    if (response != 'OK') {
      AlertHandler.getAlertWarning(response);
      return;
    }

    User user = User(phone: phone, password: password, confirmationPassword: confirmPassword, email: email, emailSponsor: emailSponsor.isEmpty ? null : emailSponsor);
    Response responseApi = await userProvider.create(user);

    if (responseApi.statusCode != HttpStatus.created) {
      String messageError = ManageError.getErrorMessage(responseApi);
      AlertHandler.getAlertWarning(messageError);
      return;
    }

    GetStorage().write(Constants.storageUserSession, responseApi.body[Constants.responseApiData]); // ALMACENAMOS LOS DATOS EN SESION
    Get.offNamedUntil(ConfigRoute.keyDepartment, (route) => false);
  }

  String isValidForm(
      String email,
      String emailSponsor,
      String phone,
      String password,
      String confirmPassword
  ) {
    if (emailSponsor.isNotEmpty) {
      if (!GetUtils.isEmail(emailSponsor)) {
        return 'El email del sponsor no tiene un formato valido.';
      }
    }
    if (email.isEmpty) return 'El email no debe estar vacío.';
    if (!GetUtils.isEmail(email)) return 'El email no tiene un formato valido.';
    if (phone.isEmpty) return 'El numero de telefono no debe estar vacío.';
    if (password.isEmpty) return 'La contraseña no debe estar vacía.';
    if (confirmPassword.isEmpty) return 'La confirmacion de la contraseña no debe estar vacía.';
    if (password != confirmPassword) return 'La confirmacion de la contraseña no coincide con la contraseña.';

    return 'OK';
  }

  List<Country> findCountriesToTextField() {
    return const [
      Country(
            name: "Honduras",
            nameTranslations: {
              "sk": "Honduras",
              "se": "Honduras",
              "pl": "Honduras",
              "no": "Honduras",
              "ja": "ホンジュラス",
              "it": "Honduras",
              "zh": "洪都拉斯",
              "nl": "Honduras",
              "de": "Honduras",
              "fr": "Honduras",
              "es": "Honduras",
              "en": "Honduras",
              "pt_BR": "Honduras",
              "sr-Cyrl": "Хондурас",
              "sr-Latn": "Honduras",
              "zh_TW": "宏都拉斯",
              "tr": "Honduras",
              "ro": "Honduras",
              "ar": "هندوراس",
              "fa": "هندوراس",
              "yue": "洪都拉斯"
            },
            flag: "🇭🇳",
            code: "HN",
            dialCode: "504",
            minLength: 8,
            maxLength: 8,
      ),
      Country(
        name: "El Salvador",
        nameTranslations: {
          "sk": "Salvádor",
          "se": "El Salvador",
          "pl": "Salwador",
          "no": "El Salvador",
          "ja": "エルサルバドル",
          "it": "El Salvador",
          "zh": "萨尔瓦多",
          "nl": "El Salvador",
          "de": "El Salvador",
          "fr": "Salvador",
          "es": "El Salvador",
          "en": "El Salvador",
          "pt_BR": "El Salvador",
          "sr-Cyrl": "Салвадор",
          "sr-Latn": "Salvador",
          "zh_TW": "薩爾瓦多",
          "tr": "El Salvador",
          "ro": "Salvador",
          "ar": "السلفادور",
          "fa": "ال سالوادور",
          "yue": "薩爾瓦多"
        },
        flag: "🇸🇻",
        code: "SV",
        dialCode: "503",
        minLength: 11,
        maxLength: 11,
      ),
  
    ];
  }
}