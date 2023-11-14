import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/payment_type.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientSelectPaymentTypeController extends GetxController {
  TextEditingController amountController = TextEditingController();
  double totalPay = Get.arguments['totalPay'];
  var isVisibleAmount = false.obs;

  List<PaymentType> getTypePayments() {
    List<PaymentType> customListTiles = [
      PaymentType(
        title: "Pago Electrónico",
        image: 'assets/img/credit_card.png',
        value: Constants.paymentTypeCard
      ),
      PaymentType(
        title: "Efectivo",
        image:  'assets/img/cash_payment.png',
        value: Constants.paymentTypeCash
      ),
    ];

    return customListTiles;
  }

  void getSelectedPayment(PaymentType paymentType) {
    if (paymentType.value == Constants.paymentTypeCash) {
      isVisibleAmount.value = true;
    } else {
      Get.toNamed(ConfigRoute.keyClientPaymentsCreate);
      isVisibleAmount.value = false;
    }
  }

  void goToNextPageByCash() {
    double amountPay = double.parse(amountController.text);
    if (amountController.text.isNotEmpty) {
      if (amountPay.isLowerThan(totalPay)) {
        AlertHandler.getAlertWarning('El monto ingresado: ${amountPay.toStringAsFixed(2)} es menor al monto a pagar: ${totalPay.toStringAsFixed(2)}');
        return;
      }
    }

    Get.toNamed(ConfigRoute.keyClientOrderOverview, arguments: {
      'typePayment': Constants.paymentTypeCash,
      'amountToPay': amountPay
    });
  }
}