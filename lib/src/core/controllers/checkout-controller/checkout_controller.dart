import 'package:assurance_bookstore/src/core/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void submitDeliveryInfo(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}save-address/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authController.token.value}',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Delivery info saved!');
      // Proceed to next screen
    } else {
      print("ERROR BODY: ${response.body}");
      showMassage('Failed to save delivery info.');
    }
  }
}
