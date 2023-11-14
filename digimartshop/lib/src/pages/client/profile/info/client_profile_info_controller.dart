import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProfileInfoController extends GetxController {

  var user = User.fromJson(GetStorage().read(Constants.storageUserSession)).obs;
  UserProvider userProvider = UserProvider();

  void signOut() {
    GetStorage().remove(Constants.storageUserSession);
    GetStorage().remove(Constants.storageShoppingBag);
    GetStorage().remove(Constants.storageAddress);
    GetStorage().remove(Constants.storageSupermarketUser);
    Get.offNamedUntil(ConfigRoute.keyLogin, (route) => false); // ELIMINA EL HISTORIAL O LA COLA DE PANTALLAS
  }

  void goToProfileUpdate() {
    Get.toNamed(ConfigRoute.keyClientProfileUpdate);
  }

  Future<List<ProfileCompletionCard>> findProfileCompletionCards() async {
    Response response = await userProvider.findCommissionByUser();
    print('BODY -> ${response.body}');

    List<ProfileCompletionCard> list = [
      ProfileCompletionCard(
        title: "Total Comisión Directa",
        icon: CupertinoIcons.creditcard,
        buttonText: 'L. ${response.body['totalDirect'].toString()}',
      ),
      ProfileCompletionCard(
        title: "Total Comisión invitado",
        icon: CupertinoIcons.graph_circle,
        buttonText: 'L. ${response.body['totalInvited'].toString()}',
      ),
      ProfileCompletionCard(
        title: "Total Bonificación",
        icon: CupertinoIcons.hourglass,
        buttonText: 'L. ${response.body['total'].toString()}',
      ),
    ];

    return list;
  }

}

class ProfileCompletionCard {
  final String title;
  final String buttonText;
  final IconData icon;
  ProfileCompletionCard({
    required this.title,
    required this.buttonText,
    required this.icon,
  });
}