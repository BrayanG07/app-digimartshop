import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/ubication/ubication.dart';
import 'package:digimartbox/src/pages/client/address/select/client_address_select_controller.dart';
import 'package:digimartbox/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientAddressSelectPage extends StatelessWidget {

  ClientAddressSelectPage({Key? key}) : super(key: key);
  final ClientAddressSelectController con = Get.put(ClientAddressSelectController());


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: _buttonNext(context),
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text(
          'Elije donde recibir tu pedido',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: GetBuilder<ClientAddressSelectController> ( builder: (value) => Stack(
        children: [
          _listAddress(context)
        ],
      )),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
          onPressed: () => con.goToNextPage(),
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15)
          ),
          child: const Text(
            'SIGUIENTE',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return FutureBuilder(
        future: con.getAddress(),
        builder: (context, AsyncSnapshot<List<Ubication>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    );
  }

  Widget _cardAddress(Ubication address, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
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
              Radio(
                value: index,
                groupValue: con.radioValue.value,
                onChanged: con.handleRadioValueChange,
              ),
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
}
