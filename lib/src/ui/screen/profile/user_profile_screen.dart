import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.find<AuthController>();
  final checkoutController = Get.find<CheckoutController>();

  String selectedGender = "Female";
  String email = "";
  String mobile = "";
  String name = "";
  String address =
      "No Address Available"; // Default value in case address is empty
  File? profileImage;

  // Future<void> pickProfileImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? pickedFile = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       profileImage = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // Fetch the profile data and set the initial values
    email = authController.emailController.text;
    mobile = authController.usernameController.text;
    name = checkoutController.nameController.text;
    address = name.isNotEmpty ? name : 'No Address Available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image section
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 50.0),
                  ),
                  CircleAvatar(
                    radius: 16.0,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Full Name
            _buildLabel("Full Name *"),
            _buildTextField(authController.username.value),

            // Email
            _buildLabel("Email Address *"),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(authController.emailController.text),
                ),
                SizedBox(width: 10.0),
                _buildVerifyButton(),
              ],
            ),

            // Mobile
            _buildLabel("Mobile Number *"),
            Row(
              children: [
                Expanded(child: _buildTextField(mobile)),
                SizedBox(width: 10.0),
                _buildVerifyButton(),
              ],
            ),

            // Gender
            _buildLabel("Gender"),
            Row(
              children: ["Male", "Female"].map((gender) {
                return Row(
                  children: [
                    Radio<String>(
                      value: gender,
                      groupValue: selectedGender,
                      onChanged: (value) =>
                          setState(() => selectedGender = value!),
                    ),
                    Text(gender),
                    SizedBox(width: 10.0),
                  ],
                );
              }).toList(),
            ),

            // Address
            _buildLabel("Present Address"),
            GestureDetector(
              onTap: () {
                // Navigate or open address screen
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "+ Add New Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 30.0),

            // Save button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: () {
                    // Save logic
                  },
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
      onPressed: () {
        // Verification logic
      },
      child: Text("Verify", style: TextStyle(color: Colors.white)),
    );
  }
}
