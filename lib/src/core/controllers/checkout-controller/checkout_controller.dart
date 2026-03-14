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
import '../../../ui/screen/book-details/components/related_book_widget.dart';
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

  Future<bool> submitDeliveryInfo(Map<String, dynamic> data) async {
    try {
      final cleanedData = data.map((key, value) {
        if (value is Rx) return MapEntry(key, value.value);
        return MapEntry(key, value);
      });

      final res = await DioConfig().dio.post(
        'save-address/', // <-- FIXED: match backend path
        data: cleanedData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Get.find<AuthController>().token.value}',
          },
        ),
      );

      // backend returns 200 on update, 201 on create (per our last changes)
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar('Success', 'Address saved successfully');
        return true;
      }

      print("Save address error: ${res.data}");
      return false;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        final newToken = await refreshToken();
        if (newToken != null) {
          return await submitDeliveryInfo(data); // retry once
        } else {
          Get.snackbar('Error', 'Session expired, please log in again.');
          Get.offAll(() => LoginScreen());
          return false;
        }
      }
      print("Error occurred: $e");
      Get.snackbar('Error', 'Failed to save address.');
      return false;
    } catch (e) {
      print("Unexpected error: $e");
      Get.snackbar('Error', 'Failed to save address.');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getSavedAddress() async {
    try {
      final token = Get.find<AuthController>().token.value;

      final response = await DioConfig().dio.get(
        'get_saved_address/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        // ❌ Not logged in
        return null;
      } else if (response.statusCode == 404 || response.statusCode == 204) {
        // ✅ No saved address for this user yet
        return null;
      } else {
        // other errors
        return null;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 204) {
        return null; // treat as "no address"
      }
      print("Error fetching saved address: $e");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitOrder(
    List<Map<String, dynamic>> cartItems, {
    required String deliveryType,
  }) async {
    try {
      final savedAddress =
          await getSavedAddress(); // may be null if user skipped save (shouldn't happen now)

      final res = await DioConfig().dio.post(
        'create-order/',
        data: {
          'cart': cartItems,
          'delivery_address': savedAddress, // backend should handle shape
          'delivery_type': deliveryType, // <-- keep ONLY this, don't override
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${authController.token.value}'},
        ),
      );

      if (res.statusCode == 200) return res.data;

      print("Order error: ${res.data}");
      return null;
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
