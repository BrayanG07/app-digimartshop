import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientPaymentsCreatePage extends StatelessWidget {
  ClientPaymentsCreatePage({Key? key}) : super(key: key);
  final ClientPaymentsCreateController controller =
      Get.put(ClientPaymentsCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              title: const Text(
                'Pago Electrónico',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          bottomNavigationBar: _buttonPay(context),
          body: ListView(
            children: [
              CreditCardWidget(
                cardNumber: controller.cardNumber.value,
                expiryDate: controller.expireDate.value,
                cardHolderName: controller.cardHolderName.value,
                cvvCode: controller.cvv.value,
                showBackView: controller.isCvvFocused.value,
                cardBgColor: Constants.colorBackgroundCardCredit,
                obscureCardNumber: true,
                obscureInitialCardNumber: false,
                isHolderNameVisible: true,
                labelCardHolder: 'TITULAR DE LA TARJETA',
                obscureCardCvv: true,
                height: 185,
                textStyle: const TextStyle(color: Colors.black87, fontSize: 15),
                width: MediaQuery.of(context).size.width,
                animationDuration: const Duration(milliseconds: 1000),
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
              CreditCardForm(
                formKey: controller.keyForm, // Required
                onCreditCardModelChange:
                    controller.onCreditCardModelChanged, // Required
                themeColor: Constants.colorPrimary,
                obscureCvv: true,
                obscureNumber: false,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                enableCvv: true,
                cardNumberValidator: (String? cardNumber) {},
                expiryDateValidator: (String? expiryDate) {},
                cvvValidator: (String? cvv) {},
                cardHolderValidator: (String? cardHolderName) {},
                onFormComplete: () {
                  // callback to execute at the end of filling card data
                },
                cardNumberDecoration: const InputDecoration(
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                  labelText: 'Número de la tarjeta',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  labelText: 'Expira en',
                  hintText: 'MM/YY',
                ),
                cvvCodeDecoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: 'Titular de la tarjeta',
                ),
                expiryDate: '',
                cvvCode: '',
                cardHolderName: '',
                cardNumber: '4111111111111111',
              ),
            ],
          ),
        ));
  }

  Widget _buttonPay(BuildContext context) {
    return Container(
      width: double.infinity, // EL BOTON OCUPA TODO EL ANCHO DEL CONTENEDOR
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: ElevatedButton(
          onPressed: () => controller.createPayment(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'PROCESAR',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
