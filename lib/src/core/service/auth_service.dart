import 'package:dio/dio.dart';
import '../configuration/dioconfig.dart';

class AuthService {
  // static final dio = DioConfig().dio;
  //
  // static Future<Response> sendOtp({required String email}) {
  //   return dio.post(sendOtpUrl, data: {'email': email});
  // }
  //
  // static Future<Response> verifyOtp({
  //   required String email,
  //   required String otp,
  // }) {
  //   return dio.post(verifyOtpUrl, data: {'email': email, 'otp': otp});
  // }
  //
  // static Future<Response> register({required SignupUserModel user}) {
  //   return dio.post(signupUrl, data: user.toJson());
  // }
  //
  // static Future<Response> login({
  //   required String email,
  //   required String password,
  // }) {
  //   return dio.post(
  //     loginByEmailUrl,
  //     data: {'email': email, 'password': password},
  //   );
  // }
  //
  // static Future<Response> socialLogin({
  //   required String idToken,
  //   required String provider,
  // }) {
  //   return dio.post(
  //     socialLoginUrl,
  //     data: {'id_token': idToken, 'provider': provider},
  //   );
  // }
  //
  // static Future<Response> getProfile() {
  //   return dio.get(getProfileUrl);
  // }
}
