import 'package:flutter/material.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Refund & Policy"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Book Refund Policy",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We want you to be satisfied with your purchase. Please read our refund and policy rules carefully:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            _buildPolicyPoint(
              "Eligibility for Refund",
              "Refunds are only applicable within 7 days of receiving your order. Books must be unused, in original condition, and accompanied by proof of purchase.",
            ),
            _buildPolicyPoint(
              "Non-Refundable Items",
              "E-books, discounted books, clearance sale items, and personalized orders are not eligible for refund.",
            ),
            _buildPolicyPoint(
              "Damaged or Wrong Book",
              "If you receive a damaged or incorrect book, please contact us immediately within 3 days. We will arrange for a replacement or refund.",
            ),
            _buildPolicyPoint(
              "Refund Process",
              "Once your return is received and inspected, we will notify you of the approval or rejection. Approved refunds will be processed within 7–10 business days.",
            ),
            _buildPolicyPoint(
              "Shipping Costs",
              "Customers are responsible for return shipping costs unless the return is due to our mistake (damaged or wrong book).",
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Example: navigate back or contact support
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade300,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "I Understand",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• $title",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
