import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../../core/models/home/banner_model.dart';
import '../../../widgets/responsive.dart';
import '../../cart-screen/cart_screen.dart';

class AutoScrollBanners extends StatefulWidget {
  final List<BannerModel> banners;

  const AutoScrollBanners({super.key, required this.banners});

  @override
  State<AutoScrollBanners> createState() => _AutoScrollBannersState();
}

class _AutoScrollBannersState extends State<AutoScrollBanners> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  final cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < widget.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: Responsive.isSmallScreen(context)
            ? MediaQuery.of(context).size.height * 0.20
            : MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width * 0.99,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.banners.length,
          itemBuilder: (context, index) {
            final banner = widget.banners[index];

            return GestureDetector(
              onTap: () async {
                // if (banner.link.isNotEmpty) {
                //   final url = Uri.parse(banner.link);
                //   if (await canLaunchUrl(url)) {
                //     await launchUrl(url);
                //   }
                // }
                final cartController = Get.find<CartController>();

                // Add all combo books to cart

                cartController.addComboToCart(banner.comboBooks);

                // Navigate to Cart Screen
                Get.to(() => CartScreen());
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      fit: BoxFit.fitHeight,
                      width: double.infinity,
                      imageUrl: banner.image.replaceFirst(
                        "http://",
                        "https://",
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),

                    // Image.network(
                    //   banner.image.replaceFirst("http://", "https://"),
                    //   fit: BoxFit.fitHeight,
                    //   width: double.infinity,
                    // ),
                  ),

                  // Combo Info Overlay
                  // if (banner.comboBooks.isNotEmpty)
                  //   Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     child: Container(
                  //       padding: EdgeInsets.only(left: 0, right: 10),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         // color: Colors.black.withOpacity(0.3),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           // Show only first book image
                  //           // ClipRRect(
                  //           //   borderRadius: BorderRadius.circular(6),
                  //           //   child: SizedBox(
                  //           //     height: 80,
                  //           //     width: 60,
                  //           //     child: CachedNetworkImage(
                  //           //       fit: BoxFit.cover,
                  //           //       imageUrl: banner.comboBooks[0].image
                  //           //           .replaceFirst("http://", "https://"),
                  //           //       placeholder: (context, url) => const Center(
                  //           //         child: CircularProgressIndicator(),
                  //           //       ),
                  //           //       errorWidget: (context, url, error) =>
                  //           //           const Icon(Icons.error),
                  //           //     ),
                  //           //   ),
                  //           // ),
                  //           const SizedBox(width: 12),
                  //           // Combo info & button
                  //           // Expanded(
                  //           //   child: Padding(
                  //           //     padding: const EdgeInsets.all(0.0),
                  //           //     child: Column(
                  //           //       crossAxisAlignment: CrossAxisAlignment.start,
                  //           //       children: [
                  //           //         // Text(
                  //           //         //   '${banner.title} ',
                  //           //         //   style: const TextStyle(
                  //           //         //     color: Colors.white,
                  //           //         //     fontWeight: FontWeight.bold,
                  //           //         //     fontSize: 14,
                  //           //         //   ),
                  //           //         //   maxLines: 2,
                  //           //         // ),
                  //           //         // Text(
                  //           //         //   '${banner.description} ',
                  //           //         //   style: const TextStyle(
                  //           //         //     color: Colors.white,
                  //           //         //     fontWeight: FontWeight.bold,
                  //           //         //     fontSize: 12,
                  //           //         //   ),
                  //           //         //   maxLines: 2,
                  //           //         // ),
                  //           //         // Text(
                  //           //         //   'Combo Offer - ${banner.comboBooks.length} Books',
                  //           //         //   style: TextStyle(
                  //           //         //     fontWeight: FontWeight.bold,
                  //           //         //     fontSize: 14,
                  //           //         //   ),
                  //           //         // ),
                  //           //         // const SizedBox(height: 5),
                  //           //         // Text(
                  //           //         //   'Total (Combo + Delivery): ${(banner.comboPrice - cartController.totalDeliveryCharge).toStringAsFixed(2)} টাকা',
                  //           //         //   style: const TextStyle(
                  //           //         //     color: Colors.white,
                  //           //         //     fontWeight: FontWeight.bold,
                  //           //         //   ),
                  //           //         // ),
                  //           //         const SizedBox(height: 5),
                  //           //         // ElevatedButton(
                  //           //         //   style: ElevatedButton.styleFrom(
                  //           //         //     backgroundColor: Colors.orange,
                  //           //         //     shape: RoundedRectangleBorder(
                  //           //         //       borderRadius: BorderRadius.circular(
                  //           //         //         50,
                  //           //         //       ),
                  //           //         //     ),
                  //           //         //   ),
                  //           //         //   onPressed: () {
                  //           //         //     final cartController =
                  //           //         //         Get.find<CartController>();
                  //           //         //
                  //           //         //     // Add all combo books to cart
                  //           //         //
                  //           //         //     cartController.addComboToCart(
                  //           //         //       banner.comboBooks,
                  //           //         //     );
                  //           //         //
                  //           //         //     // Navigate to Cart Screen
                  //           //         //     Get.to(() => CartScreen());
                  //           //         //   },
                  //           //         //   child: const Text(
                  //           //         //     'Order Combo',
                  //           //         //     style: TextStyle(color: Colors.white),
                  //           //         //   ),
                  //           //         // ),
                  //           //       ],
                  //           //     ),
                  //           //   ),
                  //           // ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
