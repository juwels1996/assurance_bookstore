import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/home/banner_model.dart';

class AutoScrollBanners extends StatefulWidget {
  final List<BannerModel> banners; // your banner list

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

    // Auto scroll every second
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
        height: MediaQuery.of(context).size.height * 0.3,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.banners.length,
          itemBuilder: (context, index) {
            final banner = widget.banners[index];
            return GestureDetector(
              onTap: () async {
                final url = Uri.parse(banner.link);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  Constants.imageUrl + banner.image,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
