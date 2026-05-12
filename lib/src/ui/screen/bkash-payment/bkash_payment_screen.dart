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

  /// Call this from HomePage.initState so cold-start callback URLs are handled.
  static void checkAndHandleCallback(BuildContext context) {
    final fullUrl = html.window.location.href;
    if (!fullUrl.contains('payment-success')) return;

    // Parse status from URL (supports both hash fragment and plain query)
    String status = '';
    String trxId = '';
    final uri = Uri.parse(fullUrl);
    status = uri.queryParameters['status'] ?? '';
    trxId = uri.queryParameters['trxID'] ?? '';
    if (status.isEmpty && uri.fragment.contains('?')) {
      final fq = uri.fragment.split('?').last;
      final fp = Uri.splitQueryString(fq);
      status = fp['status'] ?? '';
      trxId = fp['trxID'] ?? '';
    }

    if (status != 'Completed') {
      // Clear storage for failed/cancelled
      html.window.localStorage.remove('pending_order_id');
      html.window.localStorage.remove('pending_order_data');
      html.window.localStorage.remove('pending_order_amount');
      html.window.localStorage.remove('pending_is_cod');

      if (status == 'Failed' || status == 'failure') {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar('পেমেন্ট ব্যর্থ হয়েছে', 'আবার চেষ্টা করুন।',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        });
      } else if (status == 'Cancelled' || status == 'cancel') {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar('পেমেন্ট বাতিল হয়েছে', 'আপনি পেমেন্ট বাতিল করেছেন.',
              snackPosition: SnackPosition.TOP);
        });
      }
      return;
    }

    // Completed — retrieve stored order data
    final orderIdStr = html.window.localStorage['pending_order_id'];
    final orderDataStr = html.window.localStorage['pending_order_data'];
    final amountStr = html.window.localStorage['pending_order_amount'];
    final isCodStr = html.window.localStorage['pending_is_cod'];

    html.window.localStorage.remove('pending_order_id');
    html.window.localStorage.remove('pending_order_data');
    html.window.localStorage.remove('pending_order_amount');
    html.window.localStorage.remove('pending_is_cod');

    try {
      Get.find<CartController>().clearCart();
    } catch (_) {}

    if (orderIdStr == null || orderDataStr == null) return;

    final orderId = int.tryParse(orderIdStr) ?? 0;
    final orderData = json.decode(orderDataStr);
    final amountPaid = double.tryParse(amountStr ?? '0') ?? 0.0;
    final isCod = isCodStr == 'true';

    Future.delayed(const Duration(milliseconds: 800), () {
      if (isCod) {
        final rawAmount = orderData['amount'];
        final bookAmount = rawAmount is int
            ? rawAmount.toDouble()
            : double.tryParse(rawAmount?.toString() ?? '0') ?? 0.0;
        Get.snackbar(
          'অর্ডার নিশ্চিত হয়েছে (Cash on Delivery) ✓',
          'ডেলিভারি চার্জ ${amountPaid.toInt()}tk bKash-এ পরিশোধিত।\n'
              'বইয়ের মূল্য ${bookAmount.toInt()}tk ডেলিভারিতে দিন।',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 15),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          mainButton: TextButton(
            onPressed: () => Get.to(() => InvoiceScreen(orderId: orderId)),
            child: const Text('ইনভয়েস দেখুন',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      } else {
        Get.snackbar(
          'অর্ডার সফলভাবে সম্পন্ন হয়েছে ✓',
          'অর্ডার #$orderId নিশ্চিত হয়েছে।\nধন্যবাদ Assurance Publications-এ অর্ডার করার জন্য।',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 15),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          mainButton: TextButton(
            onPressed: () => Get.to(() => InvoiceScreen(orderId: orderId)),
            child: const Text('ইনভয়েস দেখুন',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      }
    });
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();

    final fullUrl = html.window.location.href;
    final isCallback = fullUrl.contains("payment-success");

    if (isCallback) {
      // Run after first frame so GetX navigation works correctly
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkPaymentResult();
      });
    } else {
      _createWebPayment();
    }

    html.window.onPopState.listen((event) {
      final url = html.window.location.href;
      if (url.contains("payment-success")) {
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
          html.window.localStorage['pending_is_cod'] = isCod.toString();

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
    final fullUrl = html.window.location.href;

    // Parse status and trxID from URL — supports both hash fragment and plain query
    // e.g. https://assurancepublication.com/#/payment-success?status=Completed&trxID=XXX
    String status = '';
    String trxId = '';

    final uri = Uri.parse(fullUrl);

    // Try plain query params first
    status = uri.queryParameters['status'] ?? '';
    trxId = uri.queryParameters['trxID'] ?? '';

    // Then try hash fragment: #/payment-success?status=Completed&trxID=...
    if ((status.isEmpty) && uri.fragment.contains('?')) {
      final fragmentQuery = uri.fragment.split('?').last;
      final fragmentParams = Uri.splitQueryString(fragmentQuery);
      status = fragmentParams['status'] ?? '';
      trxId = fragmentParams['trxID'] ?? '';
    }

    print('Payment callback — status: $status, trxID: $trxId');

    if (status == 'Completed') {
      final orderIdStr = html.window.localStorage['pending_order_id'];
      final orderDataStr = html.window.localStorage['pending_order_data'];
      final amountStr = html.window.localStorage['pending_order_amount'];
      final isCodStr = html.window.localStorage['pending_is_cod'];

      // Clear localStorage immediately
      html.window.localStorage.remove('pending_order_id');
      html.window.localStorage.remove('pending_order_data');
      html.window.localStorage.remove('pending_order_amount');
      html.window.localStorage.remove('pending_is_cod');

      // Clear cart
      try {
        Get.find<CartController>().clearCart();
      } catch (_) {}

      // Navigate to home first
      Get.offAll(() => HomePage());

      // Show invoice snackbar after a short delay so HomePage is fully built
      if (orderIdStr != null && orderDataStr != null) {
        final orderId = int.tryParse(orderIdStr) ?? 0;
        final orderData = json.decode(orderDataStr);
        final amountPaid = double.tryParse(amountStr ?? '0') ?? 0.0;
        final isCod = isCodStr == 'true';

        Future.delayed(const Duration(milliseconds: 800), () {
          if (isCod) {
            final rawAmount = orderData['amount'];
            final bookAmount = rawAmount is int
                ? rawAmount.toDouble()
                : double.tryParse(rawAmount?.toString() ?? '0') ?? 0.0;

            Get.snackbar(
              "অর্ডার নিশ্চিত হয়েছে (Cash on Delivery) ✓",
              "ডেলিভারি চার্জ ${amountPaid.toInt()}tk bKash-এ পরিশোধিত।\n"
                  "বইয়ের মূল্য ${bookAmount.toInt()}tk ডেলিভারিতে দিন।",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 15),
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(12),
              mainButton: TextButton(
                onPressed: () => Get.to(() => InvoiceScreen(orderId: orderId)),
                child: const Text(
                  "ইনভয়েস দেখুন",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            Get.snackbar(
              "অর্ডার সফলভাবে সম্পন্ন হয়েছে ✓",
              "আপনার অর্ডার #$orderId নিশ্চিত হয়েছে।\nধন্যবাদ Assurance Publications-এ অর্ডার করার জন্য।",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 15),
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(12),
              mainButton: TextButton(
                onPressed: () => Get.to(() => InvoiceScreen(orderId: orderId)),
                child: const Text(
                  "ইনভয়েস দেখুন",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        });
      }
    } else if (status == 'Failed' || status == 'failure') {
      html.window.localStorage.remove('pending_order_id');
      html.window.localStorage.remove('pending_order_data');
      html.window.localStorage.remove('pending_order_amount');
      html.window.localStorage.remove('pending_is_cod');
      Get.offAll(() => HomePage());
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.snackbar(
          "পেমেন্ট ব্যর্থ হয়েছে",
          "আবার চেষ্টা করুন।",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      });
    } else if (status == 'Cancelled' || status == 'cancel') {
      html.window.localStorage.remove('pending_order_id');
      html.window.localStorage.remove('pending_order_data');
      html.window.localStorage.remove('pending_order_amount');
      html.window.localStorage.remove('pending_is_cod');
      Get.offAll(() => HomePage());
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.snackbar(
          "পেমেন্ট বাতিল হয়েছে",
          "আপনি পেমেন্ট বাতিল করেছেন।",
          snackPosition: SnackPosition.TOP,
        );
      });
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
