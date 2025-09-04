import 'dart:io';
import 'package:assurance_bookstore/src/core/configuration/dioconfig.dart';
import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../../core/controllers/auth/auth_controller.dart';

class OrderSuccessScreen extends StatelessWidget {
  final int orderId;
  final double? amount;
  final Map<String, dynamic> orderData;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    this.amount,
    required this.orderData,
  });

  Future<void> downloadInvoice(int orderId) async {
    try {
      final token = Get.find<AuthController>().token.value;

      final response = await DioConfig().dio.get(
        'order-invoice/$orderId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes, // ✅ Expect binary PDF
        ),
      );

      if (kIsWeb) {
        // ✅ For web: trigger browser download
        final blob = html.Blob([response.data], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'invoice_$orderId.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // ✅ For mobile: save to file and open
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/invoice_$orderId.pdf');
        await file.writeAsBytes(response.data, flush: true);
        await OpenFile.open(file.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to download invoice');
      print("❌ Invoice download error: $e");
    }
  }

  Future<void> viewInvoice(int orderId) async {
    try {
      final token = Get.find<AuthController>().token.value;

      final response = await DioConfig().dio.get(
        'order-invoice/$orderId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.plain, // ✅ Expect HTML text
        ),
      );

      if (kIsWeb) {
        // Create a Blob with HTML string
        final blob = html.Blob([response.data], 'text/html');
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.window.open(url, "_blank");

        html.Url.revokeObjectUrl(url);
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to open invoice');
      print("❌ Invoice open error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Order Success'),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false, // remove back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              const Text(
                'Your order has been placed successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Order ID: #$orderId', style: const TextStyle(fontSize: 16)),
              if (amount != null)
                Text(
                  'Total Amount: ৳$amount',
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Get.to(HomePage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go to Home',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await viewInvoice(orderId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Download Invoice',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
