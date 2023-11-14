import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/payments/select/client_select_payment_type_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientSelectPaymentTypePage extends StatelessWidget {
  ClientSelectPaymentTypePage({Key? key}) : super(key: key);
  final ClientSelectPaymentTypeController controller = Get.put(ClientSelectPaymentTypeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.colorPrimary,
        foregroundColor: Colors.white,
        title: const Text("Tipo de pago"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        color: Constants.colorGreyBackground,
        child: Column(
          children: [
            Container(
              color: Constants.colorGreyBackground,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ...List.generate(
                    controller.getTypePayments().length,
                        (index) {
                      final tile = controller.getTypePayments()[index];
                      return GestureDetector(
                        onTap: () => controller.getSelectedPayment(tile),
                        child: Container(
                          height: 90,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 1), // Desplazamiento en horizontal y vertical
                              ),
                            ],
                          ),
                          child: Center(
                            child: ListTile(

                              leading: Image.asset(
                                  tile.image
                              ),
                              title: Text(
                                tile.title,
                                style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                size: 30,
                              ),
                              onTap: () => controller.getSelectedPayment(tile),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            controller.isVisibleAmount.value ? _textFieldAmount() : Container()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Constants.colorGreyBackground,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () => controller.goToNextPageByCash(),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15)
            ),
            child: const Text(
              'SIGUIENTE',
              style: TextStyle(
                  color: Colors.white
              ),
            )
        ),
      ),
    ));
  }

  Widget _textFieldAmount() {
    return Column(
      children: [
        Divider(
          height: 1,
          color: Colors.grey[600],
        ),
        Container(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          child: TextField(
            controller: controller.amountController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Billete (Opcional)',
                hintText: 'Monto',
                prefixIcon: Icon(Icons.monetization_on)
            ),
          ),
        ),
      ],
    );
  }
}