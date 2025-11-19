import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController buildSnackBar(String title, String message) {
  return Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      colorText: Colors.blue,
      backgroundColor: Colors.white,
      maxWidth: 250,
      margin: const EdgeInsets.only(bottom: 100));
}

SnackbarController buildSnackBarSuccess(String title, String message) {
  return Get.snackbar(title, message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      colorText: Colors.green,
      backgroundColor: Colors.white,
      maxWidth: 250
      // margin: const EdgeInsets.only(bottom: 300),

      );
}

SnackbarController buildSnackBarAlert(String title, String message) {
  return Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      colorText: Colors.red,
      backgroundColor: Colors.white,
      maxWidth: 250,
      margin: const EdgeInsets.only(bottom: 100),

  );
}
