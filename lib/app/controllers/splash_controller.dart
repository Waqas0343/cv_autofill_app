import 'dart:async';
import 'package:get/get.dart';
import '../screens/cv_form_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() async {
    Timer(const Duration(seconds: 3), () {
      Get.to(() => CVFormScreen());
    });
  }
}
