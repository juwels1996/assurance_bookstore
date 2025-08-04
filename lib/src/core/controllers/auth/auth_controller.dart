import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../config/dio_exception.dart';
import '../../constants/constants.dart';
import '../../utils/functions.dart';

class AuthController extends GetxController {
  var isAuthenticated = false.obs;
  var token = ''.obs;
  final storage = GetStorage(); // Optional if you want to keep using it

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final accessToken = data['access'] ?? data['token'];

        // Save in shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        await prefs.setString('email', email);

        // Optional: Also store in GetStorage
        storage.write('access_token', accessToken);

        isAuthenticated.value = true;
        token.value = accessToken;

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
    required String username,
    required String password1,
    required String password2,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.baseUrl + 'auth/registration/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'username': username,
          'password1': password1,
          'password2': password2,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final accessToken = data['access'];
        final refreshToken = data['refresh'];

        // Save in shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('email', email);
        await prefs.setString('username', username);

        storage.write('access_token', accessToken);

        isAuthenticated.value = true;
        token.value = accessToken;

        return true;
      } else {
        showMassage("Sign-up failed");
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

    storage.erase(); // optional
  }

  // ✅ AUTO LOGIN CHECK
  void checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      isAuthenticated.value = true;
    } else {
      token.value = '';
      isAuthenticated.value = false;
    }
  }
}
