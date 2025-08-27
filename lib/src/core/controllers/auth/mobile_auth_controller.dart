import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assurance_bookstore/src/core/configuration/dioconfig.dart';

import '../../../ui/screen/cart-screen/cart_screen.dart';
import '../../../ui/screen/home/home_page.dart';
import 'auth_controller.dart';

enum ApiState { initial, loading, loaded, error }

class MobileAuthController extends GetxController {
  // Reactive states
  var otpRequestState = ApiState.initial.obs;
  var otpVerifyState = ApiState.initial.obs;
  var resendTime = 0.obs;

  // Controllers for input fields
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  Timer? _timer;
  bool isBusy = false;
  String? requestedPhoneNumber;

  @override
  void onInit() {
    controller.checkAuthStatus();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  // Start resend countdown
  void startResendTimer(int seconds) {
    resendTime.value = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime.value > 0) {
        resendTime.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  // Request OTP from backend
  Future<void> requestOtp() async {
    if (isBusy) return;
    isBusy = true;
    otpRequestState.value = ApiState.loading;

    try {
      var response = await DioConfig().dio.post(
        "send-otp/",
        data: {"phone_number": phoneController.text},
      );

      requestedPhoneNumber = phoneController.text;
      startResendTimer(response.data['resend_time'] ?? 60);
      otpRequestState.value = ApiState.loaded;
      Fluttertoast.showToast(msg: "OTP sent successfully");
    } catch (e) {
      otpRequestState.value = ApiState.error;
      Get.snackbar("Error", "Failed to send OTP: $e");
    }

    isBusy = false;
  }

  Future<void> verifyOtp() async {
    if (isBusy) return;
    if (requestedPhoneNumber == null) {
      Fluttertoast.showToast(msg: "Phone number not found!");
      return;
    }

    isBusy = true;
    otpVerifyState.value = ApiState.loading;

    try {
      var response = await DioConfig().dio.post(
        "validate-otp/",
        data: {"phone_number": requestedPhoneNumber, "otp": otpController.text},
      );

      // Check if OTP verification is successful
      if (response.data['success'] == true) {
        List users = response.data['users'];

        // 🔑 save token if backend sends it
        final token = users[0]['token']; // adjust key to your API response
        final username = users.isNotEmpty ? users[0]['username'] ?? '' : '';
        final email = users.isNotEmpty ? users[0]['email'] ?? '' : '';

        if (token != null && token.isNotEmpty) {
          await controller.setAuthData(token, username, email);
        }

        otpVerifyState.value = ApiState.loaded;
        _timer?.cancel();
        Fluttertoast.showToast(msg: "OTP verified successfully");

        if (users.isNotEmpty) {
          if (users[0]['email'] == null || users[0]['email'] == "") {
            _showProfileUpdateDialog();
          } else {
            Get.offAll(() => CartScreen());
          }
        }
      } else {
        otpVerifyState.value = ApiState.error;
        Fluttertoast.showToast(msg: "OTP verification failed.");
      }
    } catch (e) {
      otpVerifyState.value = ApiState.error;
      Fluttertoast.showToast(msg: "OTP verification failed: $e");
    }

    isBusy = false;
  }

  void _showProfileUpdateDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputField(
                controller: authController.usernameController,
                label: "Username",
                icon: Icons.person,
              ),
              _buildInputField(
                controller: authController.emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              // _buildInputField(
              //   controller: authController.phoneController,
              //   label: "Phone Number",
              //   icon: Icons.phone,
              //   keyboardType: TextInputType.phone,
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call update profile API here
                _updateProfile();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    if (authController.usernameController.text.isEmpty ||
        authController.emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required!");
      return;
    }

    try {
      await authController.checkAuthStatus();

      final savedToken = authController.token.value;

      if (savedToken.isEmpty) {
        Fluttertoast.showToast(msg: "No token found. Please log in again.");
        return;
      }

      print("Bearer------------------- $savedToken");

      var response = await DioConfig().dio.post(
        // ⚠️ use PUT since your DRF view uses def put
        "profile/update/",
        data: {
          'username': authController.usernameController.text,
          'email': authController.emailController.text,
          // 'phone': authController.phoneController.text,
        },
        options: Options(headers: {'Authorization': 'Bearer $savedToken'}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Profile updated successfully");

        controller.emailname(authController.emailController.text);
        controller.username(authController.usernameController.text);

        Get.offAll(() => CartScreen());
      } else {
        Fluttertoast.showToast(msg: "Failed to update profile");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Profile update failed: $e");
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  //
  // Future<void> saveUser(dynamic user) async {
  //   if (user == null) return;
  //   await DataFields.prefs.setString("token", user['token'] ?? "");
  //   await DataFields.prefs.setString(
  //     "profile_image",
  //     user['profile_image'] ?? "",
  //   );
  //   DataFields.token = user['token'] ?? "";
  //   DataFields.profilePhotoUrl.value = user['profile_image'] ?? "";
  //   // Navigate to root screen
  //   Get.offAllNamed('/root');
  // }
}
