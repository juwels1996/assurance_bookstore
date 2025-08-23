import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assurance_bookstore/src/core/configuration/dioconfig.dart';

import '../../../ui/screen/home/home_page.dart';

enum ApiState { initial, loading, loaded, error }

class MobileAuthController extends GetxController {
  // Reactive states
  var otpRequestState = ApiState.initial.obs;
  var otpVerifyState = ApiState.initial.obs;
  var resendTime = 0.obs;

  // Controllers for input fields
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Timer? _timer;
  bool isBusy = false;
  String? requestedPhoneNumber;

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

  // Verify OTP from backend
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

        // If there are multiple users, you might need to ask the user to select the correct account

        // Redirect to Home screen or another screen
        Get.offAll(() => HomePage()); // Navigate to Home or Dashboard page

        otpVerifyState.value = ApiState.loaded;
        _timer?.cancel();
        Fluttertoast.showToast(msg: "OTP verified successfully");
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

  // Save user locally (example)
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
