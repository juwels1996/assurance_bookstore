import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../cart-screen/cart_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.find<AuthController>();
  bool isSignup = true; // Toggle between SignUp and Login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up / Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Switch between SignUp and Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => setState(() => isSignup = true),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isSignup = false),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Email Input
              TextField(
                controller: authController.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Username Input (only visible for SignUp)
              if (isSignup)
                TextField(
                  controller: authController.usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 16),

              // Password Input
              TextField(
                controller: authController.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Confirm Password (only visible for SignUp)
              if (isSignup)
                TextField(
                  controller: authController.confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 16),

              // Button for SignUp or Login
              ElevatedButton(
                onPressed: () async {
                  if (authController.emailController.text.isEmpty ||
                      authController.passwordController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter both email and password',
                    );
                    return;
                  }
                  if (isSignup) {
                    // Sign Up Flow
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
                      username1: authController
                          .usernameController
                          .text, // Use updated parameter
                      password1: authController.passwordController.text,
                      password2: authController.confirmPasswordController.text,
                    );

                    if (success) {
                      Get.snackbar('Success', 'Signup successful');
                    } else {
                      Get.snackbar('Failed', 'Signup failed');
                    }
                  } else {
                    // Login Flow
                    if (authController.emailController.text.isEmpty ||
                        authController.passwordController.text.isEmpty) {
                      Get.snackbar('Error', 'Enter email and password');
                      return;
                    }

                    final success = await authController.loginWithEmail(
                      authController.emailController.text,
                      authController.passwordController.text,
                    );

                    if (success) {
                      Get.snackbar('Success', 'Login Successful');
                      Get.to(
                        () => CartScreen(),
                      ); // Redirect to CartScreen after login
                    } else {
                      Get.snackbar(
                        'Login Failed',
                        'Please check your credentials',
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(isSignup ? "SIGN UP" : "LOGIN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
