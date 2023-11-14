import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientProfileInfoPage extends StatelessWidget {
  ClientProfileInfoPage({Key? key}) : super(key: key);
  final ClientProfileInfoController clientController =
      Get.put(ClientProfileInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.colorPrimary,
          foregroundColor: Colors.white,
          title: const Text("PERFIL"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => clientController.goToProfileUpdate(),
              icon: const Icon(Icons.settings_rounded),
            )
          ],
        ),
        body: Obx(
          () => Container(
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
                          : const AssetImage('assets/img/user_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    clientController.user.value.firstName != null
                        ? Text(
                            '${clientController.user.value.firstName} ${clientController.user.value.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text('¡Hola cliente de DigimartShop!',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            )),
                    Text(clientController.user.value.email ?? '')
                  ],
                ),
                const SizedBox(height: 30),
                FutureBuilder<List<ProfileCompletionCard>>(
                    future: clientController.findProfileCompletionCards(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Muestra un indicador de carga mientras se espera la respuesta.
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Muestra un mensaje de error si la llamada falla.
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Muestra un mensaje si no hay datos disponibles.
                        return Text('No hay datos disponibles');
                      } else {
                        // Construye la lista de tarjetas cuando los datos están disponibles.
                        final cards = snapshot.data!;
                        return SizedBox(
                          height: 180,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final card = cards[index];
                              return SizedBox(
                                width: 160,
                                child: Card(
                                  shadowColor: Colors.black12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Icon(card.icon,
                                            size: 30,
                                            color: Constants.colorPrimary),
                                        const SizedBox(height: 10),
                                        Text(
                                          card.title,
                                          textAlign: TextAlign.center,
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: Text(
                                            card.buttonText,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.only(right: 5)),
                            itemCount: cards.length,
                          ),
                        );
                      }
                    }),
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
                          leading:
                              Icon(tile.icon, color: Constants.colorPrimary),
                          title: Text(tile.title),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => tile.route == 'logout'
                              ? clientController.signOut()
                              : Get.toNamed(tile.route),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
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
    icon: Icons.location_on_outlined,
    title: "Direcciones",
    route: ConfigRoute.keyClientAddressList,
  ),
  CustomListTile(
    title: "Invitados",
    icon: CupertinoIcons.person,
    route: ConfigRoute.keyClientGuestsList,
  ),
  CustomListTile(
    title: "Ordenes",
    icon: CupertinoIcons.bag,
    route: ConfigRoute.keyClientOrderList,
  ),
  CustomListTile(
    title: "Cerrar Sesión",
    icon: CupertinoIcons.arrow_right_arrow_left,
    route: "logout",
  ),
];
