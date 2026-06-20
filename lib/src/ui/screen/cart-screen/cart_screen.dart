import 'package:assurance_bookstore/src/core/models/book-details/book-details.dart';

import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/constants/constants.dart';

import '../../../core/controllers/auth/auth_controller.dart';

import '../../../core/controllers/cart-controller/cart_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade50, // Slight background color for modern look

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
                        Get.offAll(() => HomePage());
                      },
                    ),
                    const Icon(Icons.account_circle, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      'Hello, ${authController.emailController.text.split('@')[0]}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
              );
            }
          }),
        ],
      ),

      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text("Your cart is empty"));
        }

        return Column(
          children: [
            // 🔺 1. TOP BAR (Pinned at the top)

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.red.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Items (${cartController.cartItems.length})",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "Product Price: ${cartController.totalAmount} Tk",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),

            // 📜 2. SCROLLABLE AREA (Items + Delivery + Summary)

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 🛒 List of Cart Items

                    ListView.builder(
                      shrinkWrap: true, // IMPORTANT for scrolling

                      physics:
                          const NeverScrollableScrollPhysics(), // IMPORTANT for scrolling

                      itemCount: cartController.cartItems.length,

                      itemBuilder: (context, index) {
                        final cartItem = cartController.cartItems[index];

                        if (cartItem.isCombo) {
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 📸 Combo Book Images

                                  SizedBox(
                                    height: 90,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: cartItem.comboBooks!
                                          .take(3)
                                          .map((book) {
                                        final imageUrl = book.image
                                            .replaceFirst(
                                                "http://", "https://");

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: GestureDetector(
                                            onTap: () => Get.to(() =>
                                                FullScreenImageView(
                                                    imageUrl: imageUrl)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(imageUrl,
                                                  width: 60,
                                                  height: 90,
                                                  fit: BoxFit.cover),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Combo Pack (3 Books)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '৳ ${cartItem.comboBooks!.fold<int>(0, (sum, b) => sum + (b.price ?? b.price))}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ➕➖ Quantity Buttons

                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.grey),
                                        onPressed: () => cartController
                                            .removeFromCart(cartItem),
                                      ),
                                      Obx(() => Text(
                                          '${cartItem.quantity.value}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold))),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.green),
                                        onPressed: () =>
                                            cartItem.quantity.value++,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Book Image

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      Constants.imageUrl + cartItem.item.image,
                                      height: 90,
                                      width: 65,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // Details

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.item.title ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          cartItem.item.editor ?? '',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              "${cartItem.item.price} Tk",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "${cartItem.item.price} Tk", // Put original price logic here if needed

                                              style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.grey,
                                                  fontSize: 12),
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
                                        padding: EdgeInsets.zero,

                                        constraints: const BoxConstraints(),

                                        icon: const Icon(Icons.close,
                                            color: Colors.grey, size: 20),

                                        onPressed: () => cartController
                                            .removeFromCart(cartItem
                                                .item), // Fixed to remove specific item
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => cartController
                                                .removeFromCart(cartItem.item),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: const Icon(Icons.remove,
                                                  size: 16),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(
                                                "${cartItem.quantity.value}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          GestureDetector(
                                            onTap: () => cartController
                                                .addToCart(cartItem.item),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: const Icon(Icons.add,
                                                  size: 16, color: Colors.red),
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

                    // 🚚 DELIVERY MODE SECTION

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Delivery Mode",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          Builder(builder: (context) {
                            final codAllowed = cartController.isCodAllowed;
                            if (!codAllowed && cartController.paymentMethod.value == 'cod') {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                cartController.paymentMethod.value = 'bkash';
                              });
                            }
                            return Column(
                            children: [
                              _buildModernDeliveryOption(
                                title: "Courier / Office",
                                subtitle:
                                    "অগ্রিম পেমেন্ট সম্পন্ন করুন। (Via bKash)",
                                value: 'bkash',
                                icon: Icons.local_shipping_outlined,
                                groupValue: cartController.paymentMethod.value,
                                onTap: (val) =>
                                    cartController.paymentMethod.value = val,
                              ),
                              const SizedBox(height: 10),
                              _buildModernDeliveryOption(
                                title: "Home Delivery",
                                subtitle:
                                    "অগ্রিম পেমেন্ট সম্পন্ন করুন। (Via bKash)",
                                value: 'hd',
                                icon: Icons.home_work_outlined,
                                groupValue: cartController.paymentMethod.value,
                                onTap: (val) =>
                                    cartController.paymentMethod.value = val,
                              ),
                              if (codAllowed) ...[
                              const SizedBox(height: 10),
                              _buildModernDeliveryOption(
                                title: "Cash on Delivery",
                                subtitle:
                                    "শুধু Delivery Charge পেমেন্ট করুন। বই হাতে পেয়ে বইয়ের মূল্য পরিশোধ করুন। (Via bKash)",
                                value: 'cod',
                                icon: Icons.payments_outlined,
                                groupValue: cartController.paymentMethod.value,
                                onTap: (val) =>
                                    cartController.paymentMethod.value = val,
                              ),
                              ],
                              if (!codAllowed)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    cartController.hasCombo
                                        ? "Combo package e Cash on Delivery available noy. Full payment korte hobe."
                                        : "2000 Tk er upore order e Cash on Delivery available noy. Delivery Free! Full payment korte hobe.",
                                    style: TextStyle(
                                        color: Colors.orange.shade800,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                            ],
                          );
                          }),
                        ],
                      ),
                    ),

                    // 🧾 ORDER SUMMARY SECTION

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.receipt_long, color: Colors.blue),
                                SizedBox(width: 8),
                                Text("Order Summary",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryRow(
                                "Subtotal", "${cartController.totalAmount} Tk"),
                            const SizedBox(height: 10),
                            _buildSummaryRow("VAT", "0 Tk"),
                            const SizedBox(height: 10),
                            Builder(builder: (context) {
                              final hasCombo = cartController.cartItems
                                  .any((item) => item.isCombo);

                              final deliveryCharge = hasCombo
                                  ? 0
                                  : cartController.totalDeliveryCharge;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Delivery Charge",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 15)),
                                  Container(
                                    padding: hasCombo
                                        ? const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4)
                                        : EdgeInsets.zero,
                                    decoration: hasCombo
                                        ? BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius:
                                                BorderRadius.circular(6))
                                        : null,
                                    child: Text(
                                      hasCombo ? "Free" : "$deliveryCharge Tk",
                                      style: TextStyle(
                                        color: hasCombo
                                            ? Colors.green.shade700
                                            : Colors.black87,
                                        fontWeight: hasCombo
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(height: 1, thickness: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  final isCod =
                                      cartController.paymentMethod.value ==
                                          'cod';

                                  return Text(
                                      isCod ? "Payable Now" : "Total Payable",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18));
                                }),
                                Builder(builder: (context) {
                                  return Obx(() {
                                    final isCod =
                                        cartController.paymentMethod.value ==
                                            'cod';

                                    final hasCombo = cartController.cartItems
                                        .any((item) => item.isCombo);

                                    final deliveryCharge = hasCombo
                                        ? 0
                                        : cartController.totalDeliveryCharge;

                                    final totalPayable = isCod
                                        ? deliveryCharge
                                        : cartController.totalAmount +
                                            deliveryCharge;

                                    return Text("$totalPayable Tk",
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20));
                                  });
                                }),
                              ],
                            ),
                            Obx(() {
                              if (cartController.paymentMethod.value == 'cod') {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Due on Delivery: ${cartController.totalAmount} Tk",
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }

                              return const SizedBox();
                            }),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 30), // Extra space at bottom of scroll
                  ],
                ),
              ),
            ),

            // ✅ 3. CHECKOUT BUTTON (Pinned at the bottom)

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5))
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!authController.isLoggedIn) {
                      await Get.to(() => LoginScreen());

                      if (!authController.isLoggedIn) return;
                    }

                    final method = cartController.paymentMethod.value;

                    if (method == "bkash" ||
                        method == "hd" ||
                        method == "cod") {
                      Get.to(
                          () => DeliveryAddressScreen(paymentMethod: method));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Courier/Office order placed")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Proceed to Checkout",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- HELPER METHODS FOR UI ---

  Widget _buildModernDeliveryOption({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required String groupValue,
    required Function(String) onTap,
  }) {
    bool isSelected = groupValue == value;

    Color activeColor = Colors.blue;

    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isSelected ? activeColor : Colors.grey.shade600),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 15,
                      color: isSelected ? Colors.black87 : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: activeColor)
            else
              Icon(Icons.circle_outlined, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87)),
      ],
    );
  }
}
