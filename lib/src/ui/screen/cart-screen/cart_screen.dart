import 'package:assurance_bookstore/src/ui/screen/cart-screen/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../auth/login_screen.dart';
import '../delivery-address/delivery_address_screen.dart';

class CartScreen extends StatelessWidget {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Delivery Charge"), Text("50 Tk")],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Total Payable Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "269 Tk",
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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  final authController = Get.find<AuthController>();
                  if (authController.isLoggedIn) {
                    Get.to(() => DeliveryAddressScreen());
                  } else {
                    // Go to login and after successful login, go to delivery screen
                    Get.to(() => LoginScreen())?.then((_) {
                      if (authController.isLoggedIn) {
                        Get.to(() => DeliveryAddressScreen());
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

// 🎁 Coupon Area
// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   child: Row(
//     children: [
//       Expanded(
//         child: TextField(
//           decoration: const InputDecoration(
//             hintText: "Enter Coupon/Promo Code",
//             border: OutlineInputBorder(),
//             isDense: true,
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 8,
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(width: 8),
//       ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//         ),
//         child: const Text("Apply"),
//       ),
//     ],
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 16),
//   child: Align(
//     alignment: Alignment.centerLeft,
//     child: TextButton(
//       onPressed: () {},
//       child: const Text(
//         "View available coupon",
//         style: TextStyle(color: Colors.red),
//       ),
//     ),
//   ),
// ),

// 🧾 Order Summary
