import 'package:dio/dio.dart';
import 'package:book_store/src/core/constants/constants.dart';
class DioConfig {}
static DioConfig? _instance;

  DioConfig._internal();

  factory DioConfig() {
    if (_instance == null) {
      _instance = DioConfig._internal();
    }
    return _instance!;
  }
  late final Dio _dio;
  Dio get dio => _dio;
  set dio(Dio value) {
    _dio = value;
  }
  init(){
    dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }


  // Add your configuration methods and properties here
}