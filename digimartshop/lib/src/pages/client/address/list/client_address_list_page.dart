import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/ubication/ubication.dart';
import 'package:digimartbox/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:digimartbox/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientAddressListPage extends StatelessWidget {
  ClientAddressListPage({Key? key}) : super(key: key);
  final ClientAddressListController clientAddressListController = Get.put(ClientAddressListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.white
          ),
          title: const Text(
            'Direcciones',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            _iconAddressCreate(),
          ],
        ),
        body: GetBuilder<ClientAddressListController> ( builder: (value) => Stack(
            children: [
              _listAddress(context)
            ],
          )
        ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return Container(
      color: Constants.colorGreyBackground,
      child: FutureBuilder(
          future: clientAddressListController.getAddress(),
          builder: (context, AsyncSnapshot<List<Ubication>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    itemBuilder: (_, index) {
                      return _cardAddress(snapshot.data![index], index);
                    }
                );
              }
              else {
                return NoDataWidget(textMessage: 'No hay direcciones');
              }
            }
            else {
              return NoDataWidget(textMessage: 'No hay direcciones');
            }
          }
      ),
    );
  }

  Widget _cardAddress(Ubication address, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
              Icon(
                size: 30,
                Icons.location_on,
                color: Constants.colorPrimary,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.address,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      address.neighborhood,
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

  Widget _iconAddressCreate() {
    return IconButton(
        onPressed: () => clientAddressListController.goToAddressCreate(),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        )
    );
  }
}
