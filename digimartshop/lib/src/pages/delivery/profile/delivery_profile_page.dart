import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/delivery/profile/delivery_profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class DeliveryProfilePage extends StatelessWidget {

  DeliveryProfilePage({Key? key}) : super(key: key);
  final DeliveryProfileController clientController = Get.put(DeliveryProfileController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.colorPrimary,
          foregroundColor: Colors.white,
          title: const Text("PERFIL"),
          centerTitle: true,
        ),
        body: Obx(() => Container(
          color: Constants.colorGreyBackground,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              // COLUMN THAT WILL CONTAIN THE PROFILE
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    backgroundImage: clientController.user.value.image != null
                        ? NetworkImage(clientController.user.value.image)
                        : const AssetImage('assets/img/user_profile.png') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${clientController.user.value.firstName ?? ''} ${clientController.user.value.lastName ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(clientController.user.value.email ?? '')
                ],
              ),
              const SizedBox(height: 30),
              ...List.generate(
                customListTiles.length,
                    (index) {
                  final tile = customListTiles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      child: ListTile(
                        leading: Icon(tile.icon, color: Constants.colorPrimary),
                        title: Text(tile.title),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => tile.route == 'logout' ? clientController.signOut() : Get.toNamed(tile.route),
                      ),
                    ),
                  );
                },
              )
            ],

          ),
        ),
        )
    );
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

class CustomListTile {
  final IconData icon;
  final String title;
  final String route;

  CustomListTile({
    required this.icon,
    required this.title,
    required this.route,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    title: "Ordenes",
    icon: CupertinoIcons.bag,
    route: ConfigRoute.keyDeliveryOrderList,
  ),
  CustomListTile(
    title: "Cerrar Sesión",
    icon: CupertinoIcons.arrow_right_arrow_left,
    route: "logout",
  ),
];
