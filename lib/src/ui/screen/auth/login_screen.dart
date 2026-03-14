import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/ui/screen/home/home_page.dart';
import 'package:assurance_bookstore/src/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/auth/mobile_auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../cart-screen/cart_screen.dart';
import 'mobile_otp_Screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.find<AuthController>();
  final mobileController = Get.put(MobileAuthController());
  bool isSignup = true;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;
    final backgroundColor = Colors.grey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAll(HomePage());
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   "Sign Up / Login",
                //   style: TextStyle(
                //     fontSize: 26,
                //     fontWeight: FontWeight.bold,
                //     color: primaryColor,
                //   ),
                // ),
                // const SizedBox(height: 20),
                //
                // ElevatedButton(
                //   onPressed: () {
                //     Get.to(() => MobileOtpScreen());
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue, // Button background color
                //     foregroundColor: Colors.white, // Text (and icon) color
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 24,
                //       vertical: 12,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(
                //         12,
                //       ), // Rounded corners
                //     ),
                //   ),
                //   child: Text(
                //     "Login With Phone Number",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontStyle: FontStyle.italic,
                //
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                SizedBox(height: 30),

                // Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Sign Up"),
                      selected: isSignup,
                      selectedColor: primaryColor,
                      labelStyle: TextStyle(
                        color: isSignup ? Colors.white : primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => isSignup = true),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 20, height: 22, color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Login"),
                      selected: !isSignup,
                      selectedColor: primaryColor,
                      labelStyle: TextStyle(
                        color: !isSignup ? Colors.white : primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => isSignup = false),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),
                Text(
                  "ℹ লগইন নিয়ে সমস্যা হলে 01341875192 এই নাম্বারে contact করার অনুরোধ রইলো",
                  style: context.labelSmall!.copyWith(
                    color: context.secondaryColor,
                  ),
                ),

                const SizedBox(height: 30),

                // Email
                _buildInputField(
                  controller: authController.emailController,
                  label: "Email",
                  hint: "Choose a email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Username (Sign Up only)
                if (isSignup)
                  _buildInputField(
                    controller: authController.usernameController,
                    hint: "ইউজারনাম হবে যেমন, tamin44",
                    label: "ইউজারনাম",
                    icon: Icons.person,
                  ),

                if (isSignup) const SizedBox(height: 16),

                // Password
                _buildInputField(
                  controller: authController.passwordController,
                  label: "পাসওয়ার্ড",
                  hint: "পাসওয়ার্ড দিন যেমন(12345678#)",
                  icon: Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 16),

                // Confirm Password (Sign Up only)
                if (isSignup)
                  _buildInputField(
                    controller: authController.confirmPasswordController,
                    label: "পাসওয়ার্ড",
                    hint: "পাসওয়ার্ড দিন যেমন(12345678#)",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                const SizedBox(height: 25),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      isSignup ? "SIGN UP" : "LOGIN",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     _handleGuestLogin(); // Handle guest login
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green, // Button background color
                //     foregroundColor: Colors.white, // Text (and icon) color
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 24,
                //       vertical: 12,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(
                //         12,
                //       ), // Rounded corners
                //     ),
                //   ),
                //   child: Text(
                //     "Login as Guest",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontStyle: FontStyle.italic,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGuestLogin() async {
    // Create text controllers for name and mobile number
    TextEditingController guestNameController = TextEditingController();
    TextEditingController guestMobileController = TextEditingController();

    // Show dialog to collect guest details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Guest Login"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: guestNameController,
                decoration: InputDecoration(labelText: "Enter your name"),
              ),
              TextField(
                controller: guestMobileController,
                decoration: InputDecoration(
                  labelText: "Enter your mobile number",
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (guestNameController.text.isEmpty ||
                    guestMobileController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please enter both name and mobile number',
                  );
                } else {
                  // Proceed with the guest login logic
                  _processGuestLogin(
                    guestNameController.text,
                    guestMobileController.text,
                  );
                  // Delay closing the dialog to let the login process finish
                }
              },
              child: Text("Login"),
            ),
          ],
        );
      },
    );
  }

  void _processGuestLogin(String name, String mobile) {
    Get.snackbar('Success', 'Login Successful');

    // Initialize CartController to get cartItems
    final cartController = Get.find<CartController>();

    // Check if the cart has any items
    if (cartController.cartItems.isNotEmpty) {
      // Navigate to CartScreen if there are items in the cart
      Get.to(() => CartScreen());
    } else {
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pop(context); // Close the dialog after login logic
      });
      // If cart is empty, navigate to HomePage and replace all previous screens
      Get.offAll(
        () => HomePage(),
      ); // This will replace current screen with HomePage
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String? hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          // Only show suffix icon if it's a password field
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(Icons.visibility, color: Colors.grey),
                  onPressed: () {
                    setState(() {});
                  },
                )
              : null,
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (authController.emailController.text.isEmpty ||
        authController.passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password');
      return;
    }

    if (isSignup) {
      if (authController.passwordController.text !=
          authController.confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }
      if (authController.emailController.text.isEmpty ||
          authController.usernameController.text.isEmpty ||
          authController.passwordController.text.isEmpty ||
          authController.confirmPasswordController.text.isEmpty) {
        Get.snackbar('Error', 'All fields are required');
        return;
      }
      final success = await authController.signup(
        email: authController.emailController.text,
        username1: authController.usernameController.text,
        password1: authController.passwordController.text,
        password2: authController.confirmPasswordController.text,
      );
      if (success) {
        Get.snackbar('Success', 'Signup successful');
      } else {
        Get.snackbar('Failed', 'Signup failed');
      }
    } else {
      final success = await authController.loginWithEmail(
        authController.emailController.text,
        authController.passwordController.text,
      );
      if (success) {
        Get.snackbar('Success', 'Login Successful');

        final cartController = Get.find<CartController>();

        if (cartController.cartItems.isNotEmpty) {
          Get.to(() => CartScreen());
        } else {
          Get.offAll(() => HomePage()); // replace with your homepage widget
        }
      } else {
        Get.snackbar('Login Failed', 'Please check your credentials');
      }
    }
  }
}
