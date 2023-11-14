import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/card_payment.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';

class ClientPaymentsCreateController extends GetxController {
  var cardNumber = '4111111111111111'.obs;
  var expireDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvv = ''.obs;
  var isCvvFocused = false.obs;
  GlobalKey<FormState> keyForm = GlobalKey();

  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expireDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName.toUpperCase();
    cvv.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  void createPayment() {
    String responseValidate = _validateFormPayment();
    if (responseValidate != 'OK') {
      AlertHandler.getAlertWarning(responseValidate);
      return;
    }

    List<String> dateArray = expireDate.value.split('/');

    CardPayment cardPayment = CardPayment(
        cardName: cardHolderName.value.trim(),
        cardNumber: cardNumber.value.trim(),
        cardCvv: cvv.value.trim(),
        monthCard: dateArray[0],
        yearCard: dateArray[1]
    );

    // ENVIAR LOS DATOS A LA SIGUIENTE PANTALLA
    Get.toNamed(ConfigRoute.keyClientOrderOverview, arguments: {
      'cardPayment': cardPayment.toJson(),
      'typePayment': Constants.paymentTypeCard,
      'amountToPay': 0.0
    });
  }

  String _validateFormPayment() {
    DateTime now = DateTime.now();
    int currentYear = now.year % 100;
    int currentMonth = now.month;

    if (cardNumber.value.isEmpty) return 'El número de la tarjeta no debe estar vacio';
    if (cardHolderName.value.isEmpty) return 'El titular de la tarjeta no debe estar vacio';
    if (expireDate.value.isEmpty) return 'La fecha de expiración de la tarjeta no debe estar vacia';
    if (cvv.value.isEmpty) return 'El código de seguridad de la tarjeta no debe estar vacio';

    List<String> dateArray = expireDate.value.split('/');
    int userEnteredYear = int.tryParse(dateArray[1]) ?? 0;
    int userEnteredMonth = int.tryParse(dateArray[0]) ?? 0;
    if (userEnteredYear < currentYear) return 'El año de expiración ingresado debe ser mayor o igual al año actual.';
    if (userEnteredYear == currentYear && userEnteredMonth < currentMonth) return 'El mes de expiración ingresado debe ser mayor o igual al mes actual.';

    return 'OK';
  }

}