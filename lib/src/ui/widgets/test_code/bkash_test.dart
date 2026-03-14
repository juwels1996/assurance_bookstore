// import 'dart:convert';
// import 'package:assurance_bookstore/src/core/constants/constants.dart';
// import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:html' as html;
// import 'package:http/http.dart' as http;
//
// import '../../../core/controllers/auth/auth_controller.dart';
// import '../../../core/controllers/cart-controller/cart_controller.dart';
// import '../../../core/controllers/checkout-controller/checkout_controller.dart';
// import '../../screen/delivery-address/order_success_screen.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   int? createdOrderId; // store order id after creation
//   Map<String, dynamic>? createdOrderData;
//
//   @override
//   void initState() {
//     super.initState();
//     _startPaymentFlow();
//     html.window.onPopState.listen((event) => _checkPaymentResult());
//   }
//
//   Future<void> _startPaymentFlow() async {
//     try {
//       // Step 1: Submit order first
//       final cartItems = Get.find<CartController>().cartItems
//           .map(
//             (e) => {
//               'book_id': (e.item as dynamic).id,
//               'quantity': e.quantity.value,
//             },
//           )
//           .toList();
//
//       final checkoutController = Get.find<CheckoutController>();
//       final order = await checkoutController.submitOrder(cartItems);
//
//       if (order == null) {
//         Get.snackbar("Error", "Failed to create order.");
//         return;
//       }
//
//       // Get order_id and total_price from backend response
//       final createdOrderId = order['order_id'];
//       final totalPrice = order['total_price'];
//
//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}create-bkash-payment/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${authController.token.value}',
//         },
//         body: json.encode({
//           "order_id": createdOrderId, // ✅ Now real order_id
//           "amount": "1.0",
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         print("Bkash Response: $responseData");
//
//         String? gatewayPageURL = responseData['bkashURL'];
//         if (gatewayPageURL != null) {
//           html.window.location.href = gatewayPageURL;
//         } else {
//           Get.snackbar("Error", "bKash URL not found.");
//         }
//       } else {
//         print("Failed to create payment: ${response.statusCode}");
//         print("Response body: ${response.body}");
//         Get.snackbar("Error", "Failed to initiate payment.");
//       }
//     } catch (e) {
//       print("Exception: $e");
//       Get.snackbar("Error", "Something went wrong.");
//     }
//   }
//
//   // Step 3: Handle callback URL
//   void _checkPaymentResult() {
//     final uri = Uri.base;
//     final status = uri.queryParameters['status'];
//     final trxId = uri.queryParameters['trxID'];
//
//     if (uri.toString().contains("payment-success") && status == "Completed") {
//       // Payment success -> show order success screen with real order_id
//       Get.offAll(
//         () => OrderSuccessScreen(
//           orderId: createdOrderId ?? 0,
//           orderData: {...?createdOrderData, 'trxID': trxId},
//         ),
//       );
//     } else if (status == "Failed") {
//       Get.snackbar("Payment Failed", "Please try again.");
//       Get.offAll(() => HomePage());
//     } else if (status == "Cancelled") {
//       Get.snackbar("Payment Cancelled", "You cancelled the payment.");
//       Get.offAll(() => HomePage());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Payment")),
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
