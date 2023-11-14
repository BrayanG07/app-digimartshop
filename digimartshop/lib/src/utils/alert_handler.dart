import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertHandler {
  static getAlertWarning(String response) {
    Get.snackbar('Advertencia', response, backgroundColor: Colors.white, duration: const Duration(seconds: 4));
  }

  static getAlertSuccess(String response) {
    Get.snackbar('Confirmación', response, backgroundColor: Colors.white, duration: const Duration(seconds: 4));
  }
}