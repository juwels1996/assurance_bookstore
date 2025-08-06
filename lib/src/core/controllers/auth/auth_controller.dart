import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../ui/screen/cart-screen/cart_screen.dart';
import '../../config/dio_exception.dart';
import '../../constants/constants.dart';
import '../../utils/functions.dart';

class AuthController extends GetxController {
  var isAuthenticated = false.obs;
  var token = ''.obs;
  var username = ''.obs;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    checkAuthStatus();
    super.onInit();
  }

  bool get isLoggedIn => isAuthenticated.value;

  // ✅ LOGIN
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.baseUrl + 'auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      print("-------------->>>>>");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("------------------------${data}");
        final accessToken = data['access'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        await prefs.setString('email', email);

        username.value = email.split('@')[0]; // Extracting username from email
        token.value = accessToken;
        isAuthenticated.value = true;

        return true;
      } else {
        showMassage("Login failed");
        return false;
      }
    } catch (e) {
      showApiErrorMessage(e);
      return false;
    }
  }

  // ✅ SIGN UP
  Future<bool> signup({
    required String email,
    required String username1,
    required String password1,
    required String password2,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.baseUrl + 'auth/registration/'),
        body: json.encode({
          'email': email,
          'username': username1,
          'password1': password1,
          'password2': password2,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        String accessToken = data['access']; // Access token
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('access_token', accessToken);

        username.value = email.split('@')[0]; // Extract username from email
        token.value = accessToken;
        isAuthenticated.value = true;

        // Navigate to the cart screen after signup
        Get.to(() => CartScreen());

        return true;
      } else {
        showMassage('Sign-up failed. Please check your details.');
        return false;
      }
    } catch (e) {
      showApiErrorMessage(e);
      return false;
    }
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    isAuthenticated.value = false;
    token.value = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // remove all
  }

  // ✅ AUTO LOGIN CHECK
  void checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      isAuthenticated.value = true;
      username.value = prefs.getString('email')?.split('@')[0] ?? '';
    }
  }
}
