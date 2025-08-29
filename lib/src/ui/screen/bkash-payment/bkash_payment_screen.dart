import 'dart:convert';
import 'package:assurance_bookstore/src/core/constants/constants.dart';
import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';
import '../delivery-address/order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();

    _createWebPayment();

    html.window.addEventListener("newUrl", (event) {
      final currentUrl = html.window.location.href;

      print('========>>>>${currentUrl}');

      if (currentUrl.contains("execute-bkash-payment")) {
        handleCallbackUrl(currentUrl);
      }
    });
  }

  @override
  void dispose() {
    html.window.removeEventListener("newUrl", (event) {});
    super.dispose();
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
          "amount": "1.0", // Example amount
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

          html.window.location.href = gatewayPageURL;

          // html.window.open(
          //   gatewayPageURL,
          //   "", // Open the URL in a new tab or window
          // );
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

    if (paymentID != null && status == 'success') {
      Get.snackbar("Payment Successful", "Your payment was successful!");

      // Now place the order and go to OrderSuccessScreen
      Future.delayed(Duration(milliseconds: 500), () async {
        final cartItems = Get.find<CartController>().cartItems
            .map(
              (e) => {
                'book_id': (e.item as dynamic).id,
                'quantity': e.quantity.value,
              },
            )
            .toList();

        final checkoutController = Get.find<CheckoutController>();
        final order = await checkoutController.submitOrder(cartItems);

        if (order != null) {
          Get.offAll(
            () => OrderSuccessScreen(
              orderId: order['order_id'],
              orderData: order,
            ),
          );
        }
      });
    } else if (status == 'failure') {
      Get.snackbar("Payment Failed", "Your payment failed.");
      Get.back();
    } else if (status == 'cancel') {
      Get.snackbar("Payment Cancelled", "You cancelled the payment.");
      Get.back();
    } else {
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
