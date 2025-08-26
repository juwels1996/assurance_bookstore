import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../widgets/responsive.dart';
import '../../book-details/book-details_Screen.dart';

class BookCard extends StatefulWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _hover = false;
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    final b = widget.book;
    final showCta = _hover || Responsive.isSmallScreen(context);
    final width = Responsive.cardWidth(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        width: width,
        margin: const EdgeInsets.only(left: 12, bottom: 4),
        transform: Matrix4.identity()..translate(0.0, _hover ? -2.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: _hover ? Colors.black.withOpacity(0.06) : Colors.black12,
              blurRadius: _hover ? 16 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () =>
                Get.to(() => BookDetailsScreen(bookId: b.id.toString())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: Responsive.cardImageAspect(context),
                      child: Container(
                        color: const Color(0xFFF6F7F9),
                        alignment: Alignment.center,
                        child: Image.network(
                          '${Constants.imageUrl}${b.image}',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image_rounded),
                        ),
                      ),
                    ),
                    // Discount ribbon (show if discount>0, else remove)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '২৫% ছাড়',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // CONTENT
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.titleSize(context),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // price row
                      Row(
                        children: [
                          Text(
                            '৳৮৬০',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w700,
                              fontSize: Responsive.priceSize(context),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '৳৮১০',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade500,
                              fontSize: Responsive.priceSize(context) - 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // CTA
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: showCta ? 40 : 0,
                  curve: Curves.easeOut,
                  child: showCta
                      ? InkWell(
                          onTap: () {
                            cartController.addToCart(b);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${b.title} added to cart'),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Add To Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Responsive {
  static const double smallMax = 600;
  static const double mediumMax = 800;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumMax;
  static bool isMediumScreen(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= smallMax && w < mediumMax;
  }

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < smallMax;

  static double cardWidth(BuildContext ctx) =>
      isLargeScreen(ctx) ? 180 : (isMediumScreen(ctx) ? 140 : 150);

  static double cardImageAspect(BuildContext ctx) =>
      isLargeScreen(ctx) ? 5.3 / 4 : 5.2 / 4;

  static double titleSize(BuildContext ctx) => isSmallScreen(ctx) ? 12 : 14;

  static double priceSize(BuildContext ctx) => isSmallScreen(ctx) ? 12 : 13;

  static EdgeInsets sectionHPad(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: isSmallScreen(ctx) ? 12 : 16);

  static double carouselHeight(BuildContext context) =>
      isLargeScreen(context) ? 440 : 240;

  static double carouselAspectRatio(BuildContext context) =>
      isLargeScreen(context) ? 16 / 9 : 4 / 3;
}
