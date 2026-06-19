import 'package:assurance_bookstore/src/core/controllers/auth/auth_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/book-controller/bookdetails_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/cart-controller/cart_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/checkout-controller/checkout_controller.dart';
import 'package:assurance_bookstore/src/core/controllers/home/home_controller.dart';
import 'package:assurance_bookstore/src/ui/screen/book-details/book-details_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'src/ui/screen/home/home_page.dart';

final routeObserver = RouteObserver<PageRoute>();

class MyRouteObserver extends RouteObserver<PageRoute> {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute is PageRoute && route is PageRoute) {
      print(
        'pop====>>>${route.settings.name}, back to : ${previousRoute.settings.name}',
      );
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PageRoute) {
      print('push====>>>${route.settings.name}');
    }
    super.didPush(route, previousRoute);
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Controllers are registered in main() — this is intentionally empty
    // to avoid duplicate registration
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // if (kIsWeb) {
//   //   usePathUrlStrategy(); // remove #
//   // }
//
//   await GetStorage.init();
//
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb) {
  //   usePathUrlStrategy();
  // }
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
    final authController = Get.find<AuthController>();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [MyRouteObserver()],
          title: 'Assurance Publication',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),

          initialBinding: InitialBinding(),
          initialRoute: '/',
          unknownRoute: GetPage(name: '/not-found', page: () => HomePage()),

          getPages: [
            GetPage(name: '/', page: () => HomePage()),
            GetPage(
              name: '/book/:id',
              page: () {
                final id = Get.parameters['id'] ?? '';
                if (id.isEmpty) return HomePage();
                return BookDetailsScreen(bookId: id);
              },
            ),
          ],
        );
      },
    );
  }
}
