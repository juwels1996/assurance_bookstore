import 'package:assurance_bookstore/src/core/controllers/auth/auth_controller.dart';
import 'package:assurance_bookstore/src/ui/screen/bkash-payment/bkash_payment_screen.dart';
import 'package:assurance_bookstore/src/ui/screen/delivery-address/order_success_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../ui/screen/auth/login_screen.dart';
import '../../configuration/dioconfig.dart';
import '../../constants/constants.dart';
import '../../utils/functions.dart';

class CheckoutController extends GetxController {
  final authController = Get.find<AuthController>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final flatController = TextEditingController();
  final houseController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();
  final altPhoneController = TextEditingController();
  final districtController = TextEditingController();
  final thanaController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> submitDeliveryInfo(Map<String, dynamic> data) async {
    try {
      final cleanedData = data.map((key, value) {
        if (value is Rx) return MapEntry(key, value.value);
        return MapEntry(key, value);
      });

      final response = await DioConfig().dio.post(
        'save-address/',
        data: cleanedData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Get.find<AuthController>().token.value}',
          },
        ),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Address saved successfully');
      } else {
        print("Error: ${response.data}");
      }
    } catch (e) {
      // If token is expired, attempt to refresh it
      if (e is DioError && e.response?.statusCode == 401) {
        final newToken = await refreshToken();
        if (newToken != null) {
          // Retry the original request with the new token
          submitDeliveryInfo(data);
        } else {
          // Handle token refresh failure (prompt user to log in again)
          Get.snackbar('Error', 'Session expired, please log in again.');
          Get.offAll(() => LoginScreen());
        }
      } else {
        // Handle other errors
        print("Error occurred: $e");
        Get.snackbar('Error', 'Failed to save address.');
      }
    }
  }

  Future<Map<String, dynamic>?> getSavedAddress() async {
    try {
      final token = Get.find<AuthController>()
          .token
          .value; // Get the token from AuthController
      final response = await DioConfig().dio.get(
        'get_saved_address/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Pass the token in the header
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Return the address data
      } else {
        // Handle errors if any
        return null;
      }
    } catch (e) {
      // Handle exception if any
      print("Error fetching saved address: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitOrder(
    List<Map<String, dynamic>> cartItems,
  ) async {
    try {
      final response = await DioConfig().dio.post(
        'create-order/',
        data: {'cart': cartItems},
        options: Options(
          headers: {'Authorization': 'Bearer ${authController.token.value}'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Order error: ${response.data}");
        return null;
      }
    } catch (e) {
      print("Submit order error: $e");
      Get.snackbar('Error', 'Failed to submit order.');
      return null;
    }
  }

  Future<String?> refreshToken() async {
    final response = await DioConfig().dio.post(
      'api/token/refresh/',
      data: {'refresh': Get.find<AuthController>().refreshToken.value},
    );

    if (response.statusCode == 200) {
      final newToken = response.data['access'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', newToken);
      Get.find<AuthController>().token.value = newToken;
      return newToken;
    } else {
      return null; // Token refresh failed
    }
  }
}
