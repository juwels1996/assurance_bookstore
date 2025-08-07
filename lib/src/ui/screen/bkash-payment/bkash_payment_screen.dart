import 'dart:convert';
import 'package:assurance_bookstore/src/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../../../core/controllers/auth/auth_controller.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    _createWebPayment();
  }

  Future<void> _createWebPayment() async {
    try {
      final authController = Get.find<AuthController>();
      final token = authController.token.value;

      if (token.isEmpty) {
        print("Error: User is not authenticated.");
        return; // Prevent making the request if the token is not available
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}create-bkash-payment/'), // API Endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Pass the token in the Authorization header
        },
        body: json.encode({
          "amount": "100.0", // Example amount
          "value_a": "bookstore",
          "value_b": "exampleValueB",
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("-------------${responseData}");

        // Extract the URL from the response data
        String? gatewayPageURL = responseData['bkashURL'];

        if (gatewayPageURL != null) {
          // Open the payment URL in the web browser using html.window.open equivalent in Flutter
          html.window.open(
            gatewayPageURL,
            "", // Open the URL in a new tab or window
          );
        } else {
          print("Error: 'response_url' is null in the response.");
        }
      } else {
        print("Failed to create payment: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  // This method handles the callback URL when the payment is completed
  void handleCallbackUrl(String url) {
    final uri = Uri.parse(url);
    final paymentID = uri.queryParameters['paymentID'];
    final status = uri.queryParameters['status'];

    if (paymentID != null && status != null) {
      if (status == 'success') {
        // Handle successful payment
        Get.snackbar("Payment Successful", "Your payment was successful!");
        Get.offAllNamed('/success');
      } else if (status == 'failure') {
        // Handle payment failure
        Get.snackbar(
          "Payment Failed",
          "Your payment failed. Please try again.",
        );
        Get.back();
      } else if (status == 'cancel') {
        // Handle cancelled payment
        Get.snackbar("Payment Cancelled", "Your payment was cancelled.");
        Get.back();
      }
    } else {
      // Handle missing parameters
      Get.snackbar("Error", "Missing payment details.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
