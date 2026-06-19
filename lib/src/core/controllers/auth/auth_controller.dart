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
  var emailname = ''.obs;
  final phone = "".obs;
  var refreshToken = ''.obs;
  var isCheckingAuth = true.obs;

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
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
      // Check if the email or password is null or empty
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar('Error', 'Please enter both email and password');
        return false;
      }

      final response = await http.post(
        Uri.parse(Constants.baseUrl + 'auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final accessToken = data['access'] ?? data['token'];
        final refresh = data['refresh'] ?? '';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        await prefs.setString('email', email);
        await prefs.setString('username', email.split('@')[0]);
        await prefs.setString('access_token', accessToken);
        if (refresh.isNotEmpty) {
          await prefs.setString('refresh_token', refresh);
        }

        username.value = email.split('@')[0];
        token.value = accessToken;
        refreshToken.value = refresh;
        isAuthenticated.value = true;

        return true;
      } else {
        Get.snackbar("Error", "Invalid credentials");
        return false;
      }
    } catch (e) {
      showApiErrorMessage(e);
      return false;
    }
  }

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
        String accessToken = data['access'];
        final refresh = data['refresh'] ?? '';
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', accessToken);
        await prefs.setString('access_token', accessToken);
        await prefs.setString('email', email);
        await prefs.setString('username', username1);
        if (refresh.isNotEmpty) {
          await prefs.setString('refresh_token', refresh);
        }

        username.value = username1;
        emailname.value = email;
        token.value = accessToken;
        refreshToken.value = refresh;
        isAuthenticated.value = true;

        Get.to(() => CartScreen());
        return true;
      } else {
        // Parse validation errors
        final errorBody = json.decode(response.body);

        // Collect all error messages into a single string
        String errorMsg = '';
        errorBody.forEach((key, value) {
          if (value is List) {
            errorMsg += '${value.join("\n")}\n';
          } else {
            errorMsg += '$value\n';
          }
        });

        // Show to user
        Get.snackbar(
          'Signup Failed',
          errorMsg.trim(),
          snackPosition: SnackPosition.BOTTOM,
        );

        return false;
      }
    } catch (e) {
      showApiErrorMessage(e);
      return false;
    }
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token.value = '';
    refreshToken.value = '';
    username.value = '';
    emailname.value = '';
    isAuthenticated.value = false;
  }

  // Future<void> checkAuthStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedToken = prefs.getString('token');
  //
  //   if (savedToken != null && savedToken.isNotEmpty) {
  //     token.value = savedToken;
  //     isAuthenticated.value = true;
  //     print('User is authenticated');
  //   } else {
  //     token.value = '';
  //     isAuthenticated.value = false;
  //     print('User is not authenticated');
  //   }
  // }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedRefresh = prefs.getString('refresh_token');

    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      refreshToken.value = savedRefresh ?? '';
      username.value = prefs.getString('username') ?? '';
      isAuthenticated.value = true;
    } else {
      isAuthenticated.value = false;
    }

    isCheckingAuth.value = false;
  }

  Future<void> setAuthData(
    String tokenValue,
    String usernameValue,
    String emailValue,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tokenValue);
    await prefs.setString('username', usernameValue);
    await prefs.setString('emailname', emailValue);

    token.value = tokenValue;
    username.value = usernameValue;
    isAuthenticated.value = true;

    print("Auth data saved-------------: ${token.value}");
    print("Auth data saved-------------: ${username.value}");
  }
}
