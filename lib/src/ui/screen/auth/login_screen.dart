import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/auth/mobile_auth_controller.dart';
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign Up / Login",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.stretch,
                //   children: [
                //     const Text(
                //       "Enter your mobile number",
                //       style: TextStyle(fontSize: 16),
                //     ),
                //     const SizedBox(height: 12),
                //     TextField(
                //       controller: mobileController.phoneController,
                //       keyboardType: TextInputType.phone,
                //       decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         hintText: "e.g. 016xxxxxxxx",
                //       ),
                //     ),
                //     const SizedBox(height: 16),
                //     Obx(
                //       () => ElevatedButton(
                //         onPressed:
                //             mobileController.otpRequestState.value ==
                //                 ApiState.loading
                //             ? null
                //             : () {
                //                 mobileController.requestOtp();
                //                 Get.to(() => MobileOtpScreen());
                //               },
                //         child:
                //             mobileController.otpRequestState.value ==
                //                 ApiState.loading
                //             ? const SizedBox(
                //                 height: 20,
                //                 width: 20,
                //                 child: CircularProgressIndicator(
                //                   color: Colors.white,
                //                   strokeWidth: 2,
                //                 ),
                //               )
                //             : const Text("Send OTP"),
                //       ),
                //     ),
                //   ],
                // ),

                // Title
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => MobileOtpScreen());
                  },
                  child: Text("Login With Phone Number"),
                ),
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

                const SizedBox(height: 30),

                // Email
                _buildInputField(
                  controller: authController.emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Username (Sign Up only)
                if (isSignup)
                  _buildInputField(
                    controller: authController.usernameController,
                    label: "Username",
                    icon: Icons.person,
                  ),

                if (isSignup) const SizedBox(height: 16),

                // Password
                _buildInputField(
                  controller: authController.passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 16),

                // Confirm Password (Sign Up only)
                if (isSignup)
                  _buildInputField(
                    controller: authController.confirmPasswordController,
                    label: "Confirm Password",
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
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
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
        Get.to(() => CartScreen());
      } else {
        Get.snackbar('Login Failed', 'Please check your credentials');
      }
    }
  }
}
