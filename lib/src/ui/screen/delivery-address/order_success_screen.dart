import 'package:assurance_bookstore/src/core/configuration/dioconfig.dart';
import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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

  Future<void> generateInvoice(Map<String, dynamic> order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Invoice #${order['order_id']}",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Customer Name: ${order['user']['name']}"),
              pw.Text("Phone: ${order['user']['phone']}"),
              pw.Text("Address: ${order['user']['address']}"),
              pw.SizedBox(height: 20),
              pw.Text(
                "Items:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              ...order['items'].map<pw.Widget>((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("${item['book']['title']} x ${item['quantity']}"),
                    pw.Text("${item['price']} BDT"),
                  ],
                );
              }).toList(),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: ${order['total_price']} BDT",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> downloadInvoice(int orderId) async {
    try {
      final token = Get.find<AuthController>().token.value;

      final response = await DioConfig().dio.get(
        'order-invoice/$orderId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      print("---------------${response}");

      if (kIsWeb) {
        // For web: trigger browser download
        final blob = html.Blob([response.data], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'invoice_$orderId.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile: save to file and open
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to download invoice');
      print(e);
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
              Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
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
                  await downloadInvoice(orderId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View My Orders',
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
