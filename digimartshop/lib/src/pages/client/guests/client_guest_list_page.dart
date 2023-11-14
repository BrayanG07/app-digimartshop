import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:digimartbox/src/pages/client/guests/client_guest_list_controller.dart';
import 'package:digimartbox/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientGuestListPage extends StatelessWidget {
  ClientGuestListPage({Key? key}) : super(key: key);
  final ClientGuestListController controller = Get.put(ClientGuestListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text(
          'Invitados',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<ClientAddressListController> ( builder: (value) => Stack(
        children: [
          _listGuestUsers(context)
        ],
      )
      ),
    );
  }

  Widget _listGuestUsers(BuildContext context) {
    return Container(
      color: Constants.colorGreyBackground,
      child: FutureBuilder(
          future: controller.getGuests(),
          builder: (context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    itemBuilder: (_, index) {
                      return _cardUser(snapshot.data![index], index);
                    }
                );
              }
              else {
                return NoDataWidget(textMessage: 'No hay usuarios invitados.');
              }
            }
            else {
              return NoDataWidget(textMessage: 'No hay usuarios invitados.');
            }
          }
      ),
    );
  }

  Widget _cardUser(User user, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 1), // Desplazamiento en horizontal y vertical
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                backgroundImage: user.image != null
                    ? NetworkImage(user.image)
                    : const AssetImage('assets/img/user_profile.png') as ImageProvider,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.firstName == null ? 'Invitado' : '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      user.email!,
                      style: const TextStyle(
                          fontSize: 14
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
