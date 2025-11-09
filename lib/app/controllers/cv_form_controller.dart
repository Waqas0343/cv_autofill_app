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
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController certificationsController = TextEditingController();


  void fillFields(Map<String, String> data) {
    nameController.text = data['name'] ?? '';
    emailController.text = data['email'] ?? '';
    phoneController.text = data['phone'] ?? '';
    positionController.text = data['position'] ?? '';
    addressController.text = data['address'] ?? '';
    educationController.text = data['education'] ?? '';
    linkedinController.text = data['linkedin'] ?? '';
    skillsController.text = data['skills'] ?? '';
    experienceController.text = data['experience'] ?? '';
    summaryController.text = data['summary'] ?? '';
    certificationsController.text = data['certifications'] ?? '';
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
    skillsController.dispose();
    experienceController.dispose();
    summaryController.dispose();
    certificationsController.dispose();
    super.onClose();
  }
}
