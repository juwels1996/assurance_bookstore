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
        final users = (response.data['users'] as List?) ?? [];
        final token = users.isNotEmpty ? (users[0]['token'] ?? '') : '';
        final username = users.isNotEmpty ? (users[0]['username'] ?? '') : '';
        final email = users.isNotEmpty ? (users[0]['email'] ?? '') : '';

        if (token.isNotEmpty) {
          await controller.setAuthData(token, username, email);
        }

        controller.usernameController.text = username;
        controller.emailController.text = email;

        otpVerifyState.value = ApiState.loaded;
        _timer?.cancel();
        Fluttertoast.showToast(msg: "OTP verified successfully");

        // Only show dialog if something is missing
        if (username.isEmpty || email.isEmpty) {
          _showProfileUpdateDialog();
        } else {
          Get.offAll(() => HomePage());
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
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputField(
                controller: this.controller.usernameController,
                hint: "Enter a unique username",
                label: "Enter Username",
                icon: Icons.person,
              ),
              _buildInputField(
                controller: this.controller.emailController,
                label: "Enter Email",
                icon: Icons.email,
                hint: "Enter a valid email address",
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final ok = await _updateProfile();
                if (ok) {
                  Navigator.pop(context);
                  Get.offAll(() => HomePage());
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _updateProfile() async {
    final newUsername = controller.usernameController.text.trim();
    final newEmail = controller.emailController.text.trim();

    if (newUsername.isEmpty || newEmail.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required!");
      return false;
    }

    // If values didn’t change, just proceed
    final current = controller; // wherever you keep stored username/email
    if ((current.username.value == newUsername) &&
        (current.emailname.value == newEmail)) {
      return true;
    }

    try {
      await controller.checkAuthStatus();
      final savedToken = controller.token.value;
      if (savedToken.isEmpty) {
        Fluttertoast.showToast(msg: "No token found. Please log in again.");
        return false;
      }

      final dio = DioConfig().dio;

      final response = await dio.post(
        "profile/update/",
        data: {'username': newUsername, 'email': newEmail},
        options: Options(
          headers: {'Authorization': 'Bearer $savedToken'},
          // Let us handle 4xx in code instead of throwing
          validateStatus: (code) => code != null && code >= 200 && code < 500,
        ),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Profile updated successfully");
        controller.emailname(newEmail);
        controller.username(newUsername);
        return true;
      }

      // Handle 400/409 validation errors from DRF
      final msg = _humanizeProfileErrors(response.data);
      Fluttertoast.showToast(msg: msg);
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Profile update failed: $e");
      return false;
    }
  }

  /// Converts DRF error payloads like:
  /// {"user":{"username":["A user with that username already exists."]}}
  /// {"email":["This field must be unique."]} …into friendly messages.
  String _humanizeProfileErrors(dynamic data) {
    try {
      final Map<String, dynamic> m = (data is Map<String, dynamic>) ? data : {};
      final Map<String, dynamic> user = (m['user'] is Map<String, dynamic>)
          ? m['user']
          : {};

      final List<String> messages = [];

      String? firstOf(key, [Map<String, dynamic>? map]) {
        final src = map ?? m;
        if (src[key] is List && (src[key] as List).isNotEmpty) {
          return (src[key] as List).first.toString();
        }
        return null;
      }

      // Username
      final uErr = firstOf('username', user) ?? firstOf('username');
      if (uErr != null) {
        if (uErr.toLowerCase().contains('already')) {
          messages.add(
            "This username is already taken. please enter another name",
          );
        } else {
          messages.add("Username: $uErr");
        }
      }

      // Email
      final eErr = firstOf('email', user) ?? firstOf('email');
      if (eErr != null) {
        if (eErr.toLowerCase().contains('already') ||
            eErr.toLowerCase().contains('unique')) {
          messages.add("This email is already registered.");
        } else {
          messages.add("Email: $eErr");
        }
      }

      // Generic fallback
      if (messages.isEmpty) {
        // If there’s a top-level 'detail' string, show that
        if (m['detail'] is String) return m['detail'];
        return "Couldn’t update profile. Please check your inputs.";
      }

      return messages.join(" ");
    } catch (_) {
      return "Couldn’t update profile. Please try again.";
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint, // 👈 added hint parameter
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
          hintText: hint, // 👈 show helpful text
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
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
