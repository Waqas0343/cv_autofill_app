import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_routes.dart';
import 'app/screens/cv_form_screen.dart';

void main() {
  runApp(const CVApp());
}

class CVApp extends StatelessWidget {
  const CVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "CV Auto Fill App",
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.cvForm,
      getPages: [
        GetPage(name: AppRoutes.cvForm, page: () => CVFormScreen()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}
