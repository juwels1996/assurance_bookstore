import 'dart:async';
import 'package:assurance_bookstore/src/ui/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/home/banner_model.dart';
import '../../cart-screen/combo_cart_screen.dart';

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
            ? MediaQuery.of(context).size.height * 0.25
            : MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width * 0.9,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.banners.length,
          itemBuilder: (context, index) {
            final banner = widget.banners[index];

            return GestureDetector(
              onTap: () async {
                // Normal link click
                if (banner.link.isNotEmpty) {
                  final url = Uri.parse(banner.link);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      banner.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),

                  // Combo Info Overlay
                  if (banner.comboBooks.isNotEmpty)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Combo Offer - ${banner.comboBooks.length} Books',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Total Price: \$${banner.comboPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to combo checkout with 3 books
                                Get.to(
                                  () => ComboCheckoutScreen(
                                    comboBooks: banner.comboBooks,
                                    totalPrice: banner.comboPrice,
                                  ),
                                );
                              },
                              child: const Text(
                                'Order Combo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
