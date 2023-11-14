import 'dart:io';

import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/user/signin-google.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:digimartbox/src/utils/manage_error.dart';
import 'package:digimartbox/src/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserProvider userProvider = UserProvider();

  void goToRegisterPage() {
   Get.toNamed(ConfigRoute.keyRegister);
  }

  void login() async {
    String email = emailController.text.split(' ').join('');
    String password = passwordController.text.split(' ').join('');
    String response = isValidForm(email, password);

    if (response != 'OK') {
      AlertHandler.getAlertWarning(response);
      return;
    }

    Response responseApi = await userProvider.login(email, password);
    if (responseApi.statusCode != HttpStatus.created) {
      String messageError = ManageError.getErrorMessage(responseApi);
      AlertHandler.getAlertWarning(messageError);
    } else {
      Map<String, dynamic> userToLogin = responseApi.body[Constants.responseApiData];
      GetStorage().write(Constants.storageUserSession, responseApi.body[Constants.responseApiData]); // ALMACENAMOS LOS DATOS EN SESION
      if (userToLogin['role'] == Constants.roleClient) {
        goToPageByUser(Constants.roleClient);
      } else {
        goToPageByUser(Constants.roleDelivery);
      }
    }
  }

  void signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;


    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    
    SignInGoogle signInGoogle = SignInGoogle(
      displayName: userCredential.user?.displayName ?? '',
      email: userCredential.user?.email ?? '',
      photoUrl: userCredential.user?.photoURL ?? '',
      phoneNumber: userCredential.user?.phoneNumber,
    );

    Response responseApi = await userProvider.signInWithGoogle(signInGoogle);
    if (responseApi.statusCode == HttpStatus.created) {
      GetStorage().write(Constants.storageUserSession, responseApi.body[Constants.responseApiData]); // ALMACENAMOS LOS DATOS EN SESION
      goToPageByUser(Constants.roleClient);
    } else {
      String messageError = ManageError.getErrorMessage(responseApi);
      AlertHandler.getAlertWarning(messageError);
    }
  }

  String isValidForm(String email, String password) {
    if (email.isEmpty) return 'El email no debe estar vacio.';
    if (!GetUtils.isEmail(email)) return 'El email no tiene un formato valido.';
    if (password.isEmpty) return 'La contraseña no debe estar vacia.';

    return 'OK';
  }

  void goToPageByUser(String typeUser) {
    if (typeUser == Constants.roleClient) {
      String supermarket = GetStorage().read(Constants.storageSupermarketUser) ?? '';

      if (supermarket.isNotEmpty) {
        Get.offNamed(ConfigRoute.keyClientHome);
      } else {
        Get.offNamed(ConfigRoute.keyDepartment);
      }
    }
    if (typeUser == Constants.roleDelivery) {
      Get.offNamed(ConfigRoute.keyDeliveryHome);
    }
  }
}