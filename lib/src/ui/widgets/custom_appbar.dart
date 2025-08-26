import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/auth/auth_controller.dart';
import '../../core/controllers/cart-controller/cart_controller.dart';
import '../screen/cart-screen/cart_screen.dart';
import '../screen/contact-us/contact_us.dart';
import '../screen/profile/user_profile_screen.dart';
import '../screen/home/home_page.dart';
import '../screen/auth/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final CartController cartController = Get.find<CartController>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: Image.asset(height: 40, width: 60, "assets/images/logo.jpeg"),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Assurance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Publications",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                // User info & actions
                Obx(() {
                  // Reactive update for logged-in state
                  return Row(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(() => ProfileScreen()),
                            child: Text(
                              "Hello, ${authController.username.value.isNotEmpty ? authController.username.value : 'User'}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.black),
                            onPressed: () async {
                              await authController.logout();
                              Get.snackbar(
                                "Logged Out",
                                "You have successfully logged out.",
                                backgroundColor: Colors.green.shade100,
                              );
                              Get.offAll(() => LoginScreen());
                            },
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),
                      // Cart icon with badge
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () => Get.to(() => CartScreen()),
                          ),
                          if (cartController.totalItems > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(
                                  () => Text(
                                    '${cartController.totalItems}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => ContactUsPage()),
                        child: const Text("Contact Us"),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(
              endIndent: 5,
              indent: 5,
              thickness: 0.6,
              color: Colors.grey,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
