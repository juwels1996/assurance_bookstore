import 'dart:convert';
import 'package:assurance_bookstore/src/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';
import '../delivery-address/order_success_screen.dart';
import '../home/home_page.dart';
import '../invoice_Screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();

    final uri = Uri.base;
    final isCallback = uri.toString().contains("payment-success") ||
        uri.queryParameters.containsKey('status');

    if (isCallback) {
      _checkPaymentResult();
    } else {
      _createWebPayment();
    }

    html.window.addEventListener("type", (event) {
      print('==>>>>==${html.window.location.href}');
    });

    html.window.onPopState.listen((event) => _checkPaymentResult());

    html.window.onPopState.listen((event) {
      print('==<<<<<<<==${html.window.location.href}');
      final uri = Uri.base;
      if (uri.toString().contains("payment-success")) {
        _checkPaymentResult();
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

      final isCod = cartController.paymentMethod.value == 'cod';
      final totalAmount =
          isCod ? deliveryCharge : (bookAmount + deliveryCharge);

      print("Book Amount: $bookAmount");
      print("Delivery Charge: $deliveryCharge");
      print("Total Amount to pay now: $totalAmount");

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
          // Store order data in localStorage to retrieve after redirect
          html.window.localStorage['pending_order_id'] = orderId.toString();
          html.window.localStorage['pending_order_data'] = json.encode(order);
          html.window.localStorage['pending_order_amount'] =
              totalAmount.toString();

          // Open bKash
          html.window.open(gatewayPageURL, "_self");
        } else {
          print("Error: 'bkashURL' is null in the response.");
          Get.back();
          Get.snackbar(
              "Error", "Could not initiate payment. Please try again.");
        }
      } else {
        print("Failed to create bKash payment: ${response.statusCode}");
        print("Response body: ${response.body}");
        Get.back();
        Get.snackbar("Error", "Failed to initiate bKash payment.");
      }
    } catch (e) {
      print("Exception in _createWebPayment: $e");
      Get.back();
      Get.snackbar("Error", "An unexpected error occurred.");
    }
  }

  void handleCallbackUrl(String url) {
    _checkPaymentResult();
  }

  void _checkPaymentResult() {
    final uri = Uri.base;
    final status = uri.queryParameters['status'];

    if (uri.toString().contains("payment-success") || status == "Completed") {
      final orderIdStr = html.window.localStorage['pending_order_id'];
      final orderDataStr = html.window.localStorage['pending_order_data'];
      final amountStr = html.window.localStorage['pending_order_amount'];

      if (orderIdStr != null && orderDataStr != null) {
        final orderId = int.parse(orderIdStr);
        final orderData = json.decode(orderDataStr);
        final amount = double.tryParse(amountStr ?? '0') ?? 0.0;

        // Clear storage
        html.window.localStorage.remove('pending_order_id');
        html.window.localStorage.remove('pending_order_data');
        html.window.localStorage.remove('pending_order_amount');

        // Clear cart
        Get.find<CartController>().clearCart();

        // Navigate to Home Page
        Get.offAll(() => HomePage());

        // Show success message with invoice link
        Get.snackbar(
          "Order Success",
          "Your order #$orderId has been placed successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 10),
          mainButton: TextButton(
            onPressed: () => Get.to(() => InvoiceScreen(orderId: orderId)),
            child: const Text(
              "VIEW INVOICE",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } else if (status == "Failed") {
      Get.snackbar("Payment Failed", "Please try again.");
      Get.offAll(() => HomePage());
    } else if (status == "Cancelled") {
      Get.snackbar("Payment Cancelled", "You cancelled the payment.");
      Get.offAll(() => HomePage());
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
