import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterPage extends StatelessWidget {

  RegisterPage({Key? key}) : super(key: key);
  final RegisterController registerController = Get.put(RegisterController());
  final double marginRightTextField = 25;
  final double marginLeftTextField = 25;


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
    return Obx(() => Container(
      height: MediaQuery.of(context).size.height * registerController.heightForm.value,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30, left: 30, right: 30),
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: marginLeftTextField, right: marginRightTextField),
                  child: Row(
                    children: [
                      Switch(
                        value: registerController.isSwitched.value,
                        onChanged: (value) {
                          registerController.isSwitched.value = value;
                          value ? registerController.heightForm.value = 0.60 : registerController.heightForm.value = 0.53; 
                        },
                      ),
                      const Text(
                        'Invitado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                registerController.isSwitched.value ? _textFieldEmailSponsor() : _containerEmpty(),
              ],
            ),
            _textFieldEmail(),
            _textFieldPhone(context),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(context),
          ],
        ),
      ),
    ));
  }

  Widget _imgUser(BuildContext buildContext) {
    return SafeArea( // EVITA QUE LA IMAGEN SE COLOQUE EN EL MARGEN DE LA CARGA Y SENAL DE WIFI
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {},
          child: GetBuilder<RegisterController> (
            builder: (value) => const CircleAvatar( // PARA REDONDEAR LA IMAGEN
              backgroundImage: AssetImage('assets/img/user_profile.png'),
              radius: 60,
              backgroundColor: Colors.white,
          ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.only(right: marginLeftTextField, left: marginRightTextField ),
      child: TextField(
        controller: registerController.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            hintText: 'Correo electronico',
            prefixIcon: Icon(Icons.email)
        ),
      ),
    );
  }

  Widget _textFieldPhone(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: marginRightTextField, left: marginLeftTextField, top: 5),
      child: IntlPhoneField(
        initialCountryCode: 'HN',
        countries: registerController.findCountriesToTextField(),
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
            hintText: 'Telefono',
        ),
        onChanged: (phone) {
          registerController.numberPhone.value = phone.completeNumber;
        },
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.only(right: marginRightTextField, left: marginLeftTextField),
      child: TextField(
        controller: registerController.passwordController,
        keyboardType: TextInputType.text,
        obscureText: true, // PARA MOSTRAR LOS ASTERISCOS EN VES DE TEXTO
        decoration: const InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: Icon(Icons.lock)
        ),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.only(right: marginRightTextField, left: marginLeftTextField, top: 5),
      child: TextField(
        controller: registerController.confirmPasswordController,
        keyboardType: TextInputType.text,
        obscureText: true, // PARA MOSTRAR LOS ASTERISCOS EN VES DE TEXTO
        decoration: const InputDecoration(
            hintText: 'Confirmar contraseña',
            prefixIcon: Icon(Icons.lock_outline)
        ),
      ),
    );
  }

  Widget _textFieldEmailSponsor() {
    return Container(
      margin: EdgeInsets.only(right: marginLeftTextField, left: marginRightTextField, bottom: 5),
      child: TextField(
        controller: registerController.emailSponsorController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            hintText: 'Correo electronico sponsor',
            prefixIcon: Icon(Icons.person_add_sharp)
        ),
      ),
    );
  }

  Widget _buttonRegister(BuildContext context) {
    return Container(
      width: double.infinity, // EL BOTON OCUPA TODO EL ANCHO DEL CONTENEDOR
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
      child: ElevatedButton(
          onPressed: () => registerController.register(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'REGISTRARSE',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 15),
      child: const Text(
        'INGRESA ESTA INFORMACIÓN',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
      ),
    );
  }

  Widget _containerEmpty() {
    return Container();
  }

}
