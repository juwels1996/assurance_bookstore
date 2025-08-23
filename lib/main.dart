import 'package:assurance_bookstore/src/core/controllers/auth/auth_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/book-controller/bookdetails_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/cart-controller/cart_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/checkout-controller/checkout_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'src/ui/screen/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(HomeController());
  Get.put(CartController());
  Get.put(AuthController());
  Get.put(CheckoutController());
  Get.put(BookDetailsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X size or your design base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: HomePage(),
        );
      },
    );
  }
}
