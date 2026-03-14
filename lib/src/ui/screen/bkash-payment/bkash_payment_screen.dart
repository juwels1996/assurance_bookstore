import 'dart:convert';
import 'package:assurance_bookstore/src/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();

    _createWebPayment();
    _checkPaymentResult();

    html.window.addEventListener("type", (event) {
      print('==>>>>==${html.window.location.href}');
    });

    html.window.onPopState.listen((event) => _checkPaymentResult());

    html.window.onPopState.listen((event) {
      print('==<<<<<<<==${html.window.location.href}');
      final uri = Uri.base;
      if (uri.toString().contains("payment-success")) {
        handleCallbackUrl(uri.toString());
      }
    });
  }

  @override
  void dispose() {
    html.window.removeEventListener("newUrl", (event) {});
    super.dispose();
  }

  // Future<void> _createWebPayment() async {
  //   try {
  //     final authController = Get.find<AuthController>();
  //     final token = authController.token.value;
  //
  //     if (token.isEmpty) {
  //       print("Error: User is not authenticated.");
  //       return;
  //     }
  //
  //     // Step 1: Build cart items
  //
  //     List<Map<String, dynamic>> cartItems = [];
  //
  //     final items = Get.find<CartController>().cartItems;
  //
  //     for (var item in items) {
  //       if (item.isCombo) {
  //         for (var book in item.comboBooks) {
  //           cartItems.add({
  //             'book_id': book.id,
  //             'quantity': item.quantity.value,
  //           });
  //         }
  //       } else {
  //         cartItems.add({
  //           'book_id': item.item.id,
  //           'quantity': item.quantity.value,
  //         });
  //       }
  //     }
  //
  //     // final cartItems = Get.find<CartController>().cartItems
  //     //     .map(
  //     //       (e) => e.isCombo
  //     //           ? {}
  //     //           : {'book_id': e.item.id, 'quantity': e.quantity.value},
  //     //     )
  //     //     .toList();
  //
  //     // Step 2: Create order first
  //     final checkoutController = Get.find<CheckoutController>();
  //     final cartController = Get.find<CartController>();
  //     final order = await checkoutController.submitOrder(
  //       cartItems,
  //       deliveryType: cartController.paymentMethod.value,
  //     );
  //
  //     if (order == null) {
  //       print("Error: Failed to create order.");
  //       return;
  //     }
  //
  //     final orderId = order['order_id'];
  //     final totalAmount = order['amount'] ?? "1.0";
  //
  //     // Step 3: Call backend to create bKash payment with valid order_id
  //     final response = await http.post(
  //       Uri.parse('${Constants.baseUrl}create-bkash-payment/'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode({
  //         "order_id": orderId,
  //         "amount": totalAmount.toString(),
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       print("-------------$responseData");
  //
  //       String? gatewayPageURL = responseData['bkashURL'];
  //
  //       if (gatewayPageURL != null) {
  //         Get.back();
  //
  //         html.window.open(gatewayPageURL, "_blank");
  //
  //         // html.window.location.href = gatewayPageURL;
  //       } else {
  //         print("Error: 'bkashURL' is null in the response.");
  //       }
  //     } else {
  //       print("Failed to create payment: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Exception: $e");
  //   }
  // }

  Future<void> _createWebPayment() async {
    try {
      final authController = Get.find<AuthController>();
      final cartController = Get.find<CartController>();
      final checkoutController = Get.find<CheckoutController>();
      final token = authController.token.value;

      if (token.isEmpty) {
        print("Error: User is not authenticated.");
        return;
      }

      // Build cart items for the backend
      List<Map<String, dynamic>> cartItems = [];
      for (var item in cartController.cartItems) {
        if (item.isCombo) {
          for (var book in item.comboBooks) {
            cartItems.add({
              'book_id': book.id,
              'quantity': item.quantity.value,
            });
          }
        } else {
          cartItems.add({
            'book_id': item.item.id,
            'quantity': item.quantity.value,
          });
        }
      }

      // Step 1: Create order on backend
      final order = await checkoutController.submitOrder(
        cartItems,
        deliveryType: cartController.paymentMethod.value,
      );

      if (order == null) {
        print("Error: Failed to create order.");
        return;
      }

      final orderId = order['order_id'];

      // Step 2: Calculate total amount including delivery charge
      final bookAmount = order['amount'] ?? 0;
      final deliveryCharge = cartController.totalDeliveryCharge;
      final totalAmount = bookAmount + deliveryCharge;

      print("Book Amount: $bookAmount");
      print("Delivery Charge: $deliveryCharge");
      print("Total Amount: $totalAmount");

      // Step 3: Call backend to create bKash payment
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}create-bkash-payment/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "order_id": orderId,
          "amount": totalAmount.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("bKash response new check-----------: $responseData");

        String? gatewayPageURL = responseData['bkashURL'];

        if (gatewayPageURL != null) {
          html.window.open(gatewayPageURL, "_blank");
          // Optionally navigate to Home or Cart screen immediately
          // Get.offAll(() => HomePage());
        } else {
          print("Error: 'bkashURL' is null in the response.");
        }
      } else {
        print("Failed to create bKash payment: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  void handleCallbackUrl(String url) {
    final uri = Uri.parse(url);
    final paymentID = uri.queryParameters['paymentID'];
    final status = uri.queryParameters['status'];

    if (paymentID != null && status == 'success') {
      Get.snackbar("Payment Successful", "Your payment was successful!");

      Get.back();
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

  void _checkPaymentResult() async {
    final uri = Uri.base;
    final status = uri.queryParameters['status'];

    if (uri.toString().contains("payment-success") && status == "Completed") {
      final cartItems = Get.find<CartController>().cartItems
          .map(
            (e) => {
              'book_id': (e.item as dynamic).id,
              'quantity': e.quantity.value,
            },
          )
          .toList();

      final checkoutController = Get.find<CheckoutController>();
      final cartController = Get.find<CartController>();
      final order = await checkoutController.submitOrder(
        cartItems,
        deliveryType: cartController.paymentMethod.value,
      );

      if (order != null) {
        Get.back();
      }
    } else if (status == "Failed") {
      Get.snackbar("Payment Failed", "Please try again.");
      Get.back();
    } else if (status == "Cancelled") {
      Get.snackbar("Payment Cancelled", "You cancelled the payment.");
      Get.back();
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
