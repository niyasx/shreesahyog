import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  RxBool continue1 = false.obs;

  void toggle() {
    continue1.value = !continue1.value;
  }
}
