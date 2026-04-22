import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import '../../core/constants/constants.dart';
import '../../core/controllers/auth/auth_controller.dart';

class InvoiceScreen extends StatefulWidget {
  final int orderId;

  const InvoiceScreen({super.key, required this.orderId});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Get the user's token
    final authController = Get.find<AuthController>();
    final token = authController.token.value;

    // Make sure your URL matches your Django urls.py for the invoice
    final invoiceUrl = '${Constants.baseUrl}order_invoice/${widget.orderId}/';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(invoiceUrl),
        // 🔑 THIS IS THE MAGIC PART: Passing the token so Django allows access
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice #${widget.orderId}"),
        backgroundColor: Colors.yellow,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}