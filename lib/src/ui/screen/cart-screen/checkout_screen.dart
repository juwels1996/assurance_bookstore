import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/controllers/cart-controller/cart_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final total = cartController.totalAmount;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Items: ${cartController.cartItems.length}"),
            Text("Total Price: ${total} Tk"),
            const Text("Delivery Charge: 50 Tk"),
            const Divider(),

            // Add address or phone input
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: "Delivery Address",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Confirm Order"),
            ),
          ],
        ),
      ),
    );
  }
}
