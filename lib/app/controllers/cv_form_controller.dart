import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CVFormController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController  emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();


  void fillFields(Map<String, String> data) {
    nameController.text = data['name'] ?? '';
    emailController.text = data['email'] ?? '';
    phoneController.text = data['phone'] ?? '';
    positionController.text = data['position'] ?? '';
    addressController.text = data['address'] ?? '';
    educationController.text = data['education'] ?? '';
    linkedinController.text = data['linkedin'] ?? '';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    addressController.dispose();
    educationController.dispose();
    linkedinController.dispose();
    super.onClose();
  }
}
