import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/functions.dart';

void showApiErrorMessage(dynamic response) async {
  if (response is DioException) {
    handleDioException(response);
  } else {
    if (kDebugMode) {
      print("exception=================$response");
    }
    showMassage(response.toString());
  }
}

void handleDioException(DioException response) async {
  if (kDebugMode) {
    print('DioException=================${response.type}');
  }
  switch (response.type) {
    case DioExceptionType.connectionTimeout:
      showMassage('Connection Timeout');
      break;
    case DioExceptionType.receiveTimeout:
      showMassage('Receive Timeout');
      break;
    case DioExceptionType.sendTimeout:
      showMassage('Send Timeout');
      break;
    case DioExceptionType.cancel:
      showMassage('Request Cancelled');
      break;
    case DioExceptionType.connectionError:
      showMassage(response.message ?? 'Check your internet connection');
      break;
    case DioExceptionType.badResponse:
      handleBadResponse(response);
      break;
    default:
      showMassage(response.message ?? 'Unknown DioException');
  }
}

void handleBadResponse(DioException response) async {
  final statusCode = response.response?.statusCode;
  switch (statusCode) {
    case 401:
      showMassage('Unauthorized');
      logout();
      break;
    case 404:
      showMassage('(404) Not Found');
      break;
    case 500:
      showMassage(' (500) Internal Server Error');
      break;

    default:
      showMassage('${response.response?.data['message'] ?? 'Unknown Error'}');
  }
}
