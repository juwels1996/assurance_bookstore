import 'package:assurance_bookstore/src/core/models/book-details/book-details.dart';
import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/constants.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/checkout-controller/checkout_controller.dart';
import '../../widgets/full_screen_preview.dart';
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
                      'Hello, ${authController.emailController.text.split('@')[0]}',
                      // Display the first part of the email as username
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
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.red.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Items (${cartController.cartItems.length})",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total Product Price = ${cartController.totalAmount} Tk",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // 🛒 List of Cart Items
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems[index];
                  print("-----------${cartController.cartItems.length}");

                  if (cartItem.isCombo) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 📸 Combo Book Images
                            SizedBox(
                              height: 100, // only constrain height
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min, // let row wrap content
                                children: cartItem.comboBooks!.take(3).map((
                                  book,
                                ) {
                                  final imageUrl = book.image.replaceFirst(
                                    "http://",
                                    "https://",
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: GestureDetector(
                                      onTap: () => Get.to(
                                        () => FullScreenImageView(
                                          imageUrl: imageUrl,
                                        ),
                                      ),
                                      child: Hero(
                                        tag: imageUrl,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                imageUrl,
                                                width: 70,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.zoom_in,
                                              color: Colors.white70,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // 📄 Title & Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Combo Pack (3 Books)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '৳ ${cartItem.comboBooks!.fold<int>(0, (sum, b) => sum + (b.price ?? b.price))}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ➕➖ Quantity Buttons
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () =>
                                      cartController.removeFromCart(cartItem),
                                ),
                                Obx(
                                  () => Text(
                                    '${cartItem.quantity.value}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => cartItem.quantity.value++,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
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
                                Constants.imageUrl + cartItem.item.image,
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
                                    cartItem.item.title ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    cartItem.item.editor ?? '',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "${cartItem.item.price} Tk",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${cartItem.item.price} ----->>>Tk",
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
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
                                      onPressed: () => cartController
                                          .removeFromCart(cartItem.item),
                                    ),
                                    Text("${cartItem.quantity.value}"),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => cartController.addToCart(
                                        cartItem.item,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
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
                    "Delivery Mode",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'bkash',
                        groupValue: cartController.paymentMethod.value,
                        onChanged: (value) {
                          setState(() {
                            cartController.paymentMethod.value = value!;
                          });
                        },
                      ),
                      const Text(
                        "Courier/Office(advance payment delivery charge)",
                      ),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: 'hd',
                        groupValue: cartController.paymentMethod.value,
                        onChanged: (value) {
                          setState(() {
                            cartController.paymentMethod.value = value!;
                          });
                        },
                      ),
                      const Text(
                        "Home Delivery(advance payment delivery charge)",
                      ),
                    ],
                  ),
                  RadioListTile<String>(
                    title: const Text("Cash on Delivery"),
                    value: 'cod',
                    groupValue: cartController.paymentMethod.value,
                    onChanged: (value) =>
                        cartController.paymentMethod.value = value!,
                  ),
                ],
              ),
            ),

            // Order Summary
            // ✅ ORDER SUMMARY (fixed reactive + combo logic)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(() {
                final hasCombo = cartController.cartItems.any(
                  (item) => item.isCombo,
                );
                final deliveryCharge = hasCombo
                    ? 0
                    : cartController.totalDeliveryCharge;
                final totalPayable =
                    cartController.totalAmount + deliveryCharge;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal"),
                        Text("${cartController.totalAmount} Tk"),
                      ],
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
                        const Text("Delivery Charge"),
                        Text(
                          hasCombo ? "Free" : "$deliveryCharge Tk",
                          style: TextStyle(
                            color: hasCombo ? Colors.green : Colors.black,
                            fontWeight: hasCombo
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Payable Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "$totalPayable Tk",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final authController = Get.find<AuthController>();

                  if (!authController.isLoggedIn) {
                    await Get.to(() => LoginScreen());

                    if (!authController.isLoggedIn) {
                      return; // user still not logged in
                    }
                  }

                  if (cartController.paymentMethod == "bkash" ||
                      cartController.paymentMethod == "hd" ||
                      cartController.paymentMethod == "cod") {
                    Get.to(
                      () => DeliveryAddressScreen(
                        paymentMethod: cartController.paymentMethod.value,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Courier/Office order placed"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Proceed to Checkout"),
              ),
            ),
          ],
        );
      }),
    );
  }
}
