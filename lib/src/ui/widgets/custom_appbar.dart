import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../core/controllers/auth/auth_controller.dart';
import '../screen/auth/login_screen.dart';
import '../screen/profile/user_profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Title
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

                // Search bar
                // Expanded(
                //   child: Container(
                //     height: 38,
                //     padding: const EdgeInsets.symmetric(horizontal: 12),
                //     decoration: BoxDecoration(
                //       color: Colors.grey[200],
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Row(
                //       children: const [
                //         Icon(Icons.search, color: Colors.grey),
                //         SizedBox(width: 8),
                //         Expanded(
                //           child: TextField(
                //             decoration: InputDecoration(
                //               hintText: "Search for books",
                //               border: InputBorder.none,
                //               isCollapsed: true,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(width: 16),

                // Icons
                Row(
                  // children: [
                  //   IconButton(
                  //     icon: const Icon(
                  //       Icons.shopping_cart,
                  //       color: Colors.black,
                  //     ),
                  //     onPressed: () {},
                  //   ),
                  // ],
                ),
                if (authController.isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.home, color: Colors.black),
                          onPressed: () {
                            // Use Future.delayed to avoid rebuild during navigation
                            Future.delayed(Duration(milliseconds: 500), () {
                              Get.offAll(
                                () => HomePage(),
                              ); // Navigate to Home Screen
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ProfileScreen());
                          },
                          child: Text(
                            "Hello, ${authController.username.value}",
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
                  ),
                // If not logged in, show the login button
                if (!authController.isLoggedIn)
                  IconButton(
                    icon: const Icon(Icons.login, color: Colors.black),
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                  ),
                // Phone number button
                // TextButton.icon(
                //   style: TextButton.styleFrom(
                //     backgroundColor: Colors.grey[300],
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   onPressed: () {},
                //   icon: const Icon(Icons.phone, color: Colors.black),
                //   label: const Text(
                //     "01323-112233",
                //     style: TextStyle(color: Colors.black),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 8),
            Divider(
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
