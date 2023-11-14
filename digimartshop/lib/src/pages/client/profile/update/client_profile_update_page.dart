import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/profile/update/client_profile_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientProfileUpdatePage extends StatelessWidget {
  ClientProfileUpdatePage({Key? key}) : super(key: key);
  final ClientProfileUpdateController clientController = Get.put(ClientProfileUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _imgUser(context),
          _buttonBack()
        ],
      ),
    );
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              )
          ),
        )
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity, // ANCHO DE TODA LA PANTALLA
      height: MediaQuery.of(context).size.height * 0.35, // 35 % del alto de la pantalla
      color: Constants.colorPrimary,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.56,// 45 % del alto,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30, left: 20, right: 20),
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
      child: SingleChildScrollView( // DE ESTA MANERA EL FORMULARIO TIENE SCROLL CUANDO EL TECLADO APARECE
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldName(),
            _textFieldLastName(),
            _textFieldPhone(),
            _textFieldDni(),
            _buttonUpdated(context),
          ],
        ),
      ),
    );
  }

  Widget _imgUser(BuildContext buildContext) {
    return SafeArea( // EVITA QUE LA IMAGEN SE COLOQUE EN EL MARGEN DE LA CARGA Y SENAL DE WIFI
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => clientController.showAlertDialog(buildContext),
          child: GetBuilder<ClientProfileUpdateController> (
            builder: (value) => CircleAvatar( // PARA REDONDEAR LA IMAGEN
              backgroundImage: clientController.imageFile != null
                  ? FileImage(clientController.imageFile!)
                  : clientController.user.image != null
                      ? NetworkImage(clientController.user.image)
                      : const AssetImage('assets/img/user_profile.png') as ImageProvider,
              radius: 60,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldDni() {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, top: 10),
      child: TextField(
        controller: clientController.dniController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'DNI',
            hintText: 'DNI',
            prefixIcon: Icon(Icons.numbers)
        ),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, top: 10),
      child: TextField(
        controller: clientController.nameController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nombre',
            hintText: 'Nombre',
            prefixIcon: Icon(Icons.person)
        ),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, top: 10),
      child: TextField(
        controller: clientController.lastnameController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Apellido',
            hintText: 'Apellido',
            prefixIcon: Icon(Icons.person_outline)
        ),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, top: 10),
      child: TextField(
        controller: clientController.phoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Telefono',
            hintText: 'Telefono',
            prefixIcon: Icon(Icons.phone)
        ),
      ),
    );
  }

  Widget _buttonUpdated(BuildContext context) {
    return Container(
      width: double.infinity, // EL BOTON OCUPA TODO EL ANCHO DEL CONTENEDOR
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: ElevatedButton(
          onPressed: () => clientController.updateUser(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'ACTUALIZAR',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 25),
      child: const Text(
        'INGRESA ESTA INFORMACIÓN',
        style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }

}
