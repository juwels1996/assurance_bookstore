import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/constants.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';
import '../auth/login_screen.dart';
import '../delivery-address/delivery_address_screen.dart';
import '../home/home_page.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();

  String paymentMethod = 'bkash'; // Default payment method is bKash

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        actions: [
          Obx(() {
            if (authController.isLoggedIn) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home, color: Colors.black),
                      onPressed: () {
                        Get.to(() => HomePage()); // Navigate to Home Screen
                      },
                    ),
                    Icon(Icons.account_circle, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      'Hello, ${authController.emailController.text.split('@')[0]}', // Display the first part of the email as username
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Get.to(() => LoginScreen()); // Navigate to login screen
                },
              );
            }
          }),
        ],
      ),
      body: Obx(() {
        final items = cartController.cartItems;
        final total = cartController.totalAmount;

        return Column(
          children: [
            // 🔺 Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.red.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Items (${items.length})",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Total Product Price = ${cartController.totalPrice} Tk",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // 🛒 List of Cart Items
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final book = item.book;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              Constants.imageUrl + book.image.toString(),
                              height: 80,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  book.title ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  book.editor ?? '',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "${book.discountedPrice} Tk",
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${book.price} ----->>>Tk",
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Quantity and Remove
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => cartController.clearCart(),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        cartController.removeFromCart(book),
                                  ),
                                  Text("${item.quantity.value}"),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        cartController.addToCart(book),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Payment Method Selection (bKash or COD)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Payment Method",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'bkash',
                        groupValue: cartController.paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            cartController.paymentMethod = value!;
                          });
                        },
                      ),
                      const Text("bKash"),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: 'cod',
                        groupValue: cartController.paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            cartController.paymentMethod = value!;
                          });
                        },
                      ),
                      const Text("Cash on Delivery (COD)"),
                    ],
                  ),
                ],
              ),
            ),

            // Order Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text("Subtotal"), Text("$total Tk")],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("VAT"), Text("0 Tk")],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery Charge"),
                      Text("${cartController.totalDeliveryCharge} Tk"),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Payable Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${cartController.totalAmount + cartController.totalDeliveryCharge} Tk",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Proceed to Checkout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  final authController = Get.find<AuthController>();
                  if (authController.isLoggedIn) {
                    Get.to(
                      () => DeliveryAddressScreen(
                        paymentMethod: cartController.paymentMethod,
                      ),
                    );
                  } else {
                    // Go to login and after successful login, go to delivery screen
                    Get.to(() => LoginScreen())?.then((_) {
                      if (authController.isLoggedIn) {
                        Get.to(
                          () => DeliveryAddressScreen(
                            paymentMethod: cartController.paymentMethod,
                          ),
                        );
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Proceed to Checkout----"),
              ),
            ),
          ],
        );
      }),
    );
  }
}
