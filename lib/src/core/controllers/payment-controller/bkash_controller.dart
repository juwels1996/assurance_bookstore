import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';

class BkashPaymentController extends GetxController {
  RxString paymentUrl = ''.obs;
  RxString paymentId = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> createBkashPayment(int orderId, double amount) async {
    isLoading.value = true;

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}create-bkash-payment/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'order_id': orderId, 'amount': amount}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      paymentUrl.value = data['bkashURL'];
      paymentId.value = data['paymentID'];
      isLoading.value = false;
    } else {
      // Handle error
      print("Failed to create bKash payment");
      isLoading.value = false;
    }
  }
}
