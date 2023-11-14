import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientAddressCreatePage extends StatelessWidget {

  ClientAddressCreatePage({Key? key}) : super(key: key);
  final ClientAddressClientController controller = Get.put(ClientAddressClientController());
  final double marginHoTextField = 28;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textNewAddress(context),
          _iconBack()
        ],
      ),
    );
  }

  Widget _iconBack() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.white,
            )
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Constants.colorPrimary,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3, left: 30, right: 30),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 0.75)
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldAddress(),
            _textFieldNeighborhood(),
            _textFieldRefPoint(context),
            const SizedBox(height: 20),
            _buttonCreate(context)
          ],
        ),
      ),
    );
  }



  Widget _textFieldAddress() {
    return Container(
      margin: EdgeInsets.only(right: marginHoTextField, left: marginHoTextField, top: 5),
      child: TextField(
        controller: controller.addressController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Dirección',
            hintText: 'Dirección',
            prefixIcon: Icon(Icons.location_on)
        ),
      ),
    );
  }

  Widget _textFieldNeighborhood() {
    return Container(
      margin: EdgeInsets.only(right: marginHoTextField, left: marginHoTextField, top: 10),
      child: TextField(
        controller: controller.neighborhoodController,
        maxLines: null,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Colonia',
            hintText: 'Barrio',
            prefixIcon: Icon(Icons.location_city)
        ),
      ),
    );
  }

  Widget _textFieldRefPoint(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: marginHoTextField, left: marginHoTextField, top: 10),
      child: TextField(
        onTap: () => controller.openGoogleMaps(context),
        controller: controller.refPointController,
        autofocus: false, // Evitar que abrir el teclado
        focusNode: AlwaysDisabledFocusNode(),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Punto de referencia',
            prefixIcon: Icon(Icons.map)
        ),
      ),
    );
  }
  
  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton(
          onPressed: () {
            controller.createAddress();
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15)
          ),
          child: const Text(
            'CREAR DIRECCIÓN',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _textNewAddress(BuildContext context) {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: Column(
          children: const [
            Icon(Icons.location_on_outlined, size: 100, color: Colors.white),
            Text(
              'NUEVA DIRECCIÓN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: const Text(
        'INGRESA ESTA INFORMACIÓN',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

