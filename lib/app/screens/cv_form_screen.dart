import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cv_form_controller.dart';
import '../utils/file_helper.dart';

class CVFormScreen extends StatelessWidget {
   CVFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CVFormController controller = Get.put(CVFormController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload CV & Auto Fill",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: controller.nameController,
              decoration:  InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.emailController,
              decoration:  InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.phoneController,
              decoration:  InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.positionController,
              decoration:  InputDecoration(
                labelText: 'Job Position',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.addressController,
              decoration:  InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.educationController,
              decoration:  InputDecoration(
                labelText: 'Education',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.linkedinController,
             decoration:  InputDecoration(
              labelText: 'Linkedin Url',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:  BorderSide(
                  color:  Colors.green,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:  BorderSide(
                  color:  Colors.green,
                  width: 2.0,
                ),
              ),
            ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.skillsController,
              decoration:  InputDecoration(
                labelText: 'Skills',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.experienceController,
              decoration:  InputDecoration(
                labelText: 'Experience',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.summaryController,
              maxLines: 6,
              decoration:  InputDecoration(
                labelText: 'Profile Summary',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.certificationsController,
              decoration:  InputDecoration(
                labelText: 'Certifications',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                    color:  Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () async {
                final file = await pickCVFile();
                if (file != null) {
                  Get.snackbar('Processing...', 'Extracting text from CV');
                  final text = await extractCVText(file);
                  final data = parseCVData(text);
                  controller.fillFields(data);
                  Get.snackbar('Success', 'Fields auto-filled successfully!');
                }
              },
              icon:  Icon(Icons.upload_file, color: Colors.white, size: 22),
              label:  Text(
                "Upload CV File",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFF3876F2),
                padding:  EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
