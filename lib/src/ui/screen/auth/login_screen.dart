import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();

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

              // 📧 Email Input
              TextField(
                controller: authController.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // 👤 Username Input
              TextField(
                controller: authController.usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // 🔑 Password Input
              TextField(
                controller: authController.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // 🔁 Confirm Password
              TextField(
                controller: authController.confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // ✅ SIGN UP Button
              ElevatedButton(
                onPressed: () async {
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
                    username: authController.usernameController.text,
                    password1: authController.passwordController.text,
                    password2: authController.confirmPasswordController.text,
                  );

                  if (success) {
                    Get.back();
                    Get.snackbar('Success', 'Signup successful');
                  } else {
                    Get.snackbar('Failed', 'Signup failed');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("SIGN UP"),
              ),

              const SizedBox(height: 12),

              // 🔐 LOGIN Button
              ElevatedButton(
                onPressed: () async {
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
                    Get.back(); // or redirect to home screen
                    Get.snackbar('Success', 'Login Successful');
                  } else {
                    Get.snackbar(
                      'Login Failed',
                      'Please check your credentials',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("LOGIN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
