import 'package:assurance_bookstore/src/core/controllers/cart-controller/cart_controller.dart';
import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:assurance_bookstore/src/ui/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/book-details/book-details.dart';
import '../book-details_Screen.dart';

class BookDetailsCard extends StatefulWidget {
  final Book book;

  const BookDetailsCard({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailsCard> createState() => _BookDetailsCardState();
}

final CartController cartController = Get.find();

class _BookDetailsCardState extends State<BookDetailsCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.book;
    final showCta = isHovered || Responsive.isSmallScreen(context);
    final width = Responsive.cardWidth(context);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        width: width,
        margin: const EdgeInsets.only(left: 12, bottom: 4),
        transform: Matrix4.identity()..translate(0.0, isHovered ? -2.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? Colors.black.withOpacity(0.06)
                  : Colors.black12,
              blurRadius: isHovered ? 16 : 10,
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
                // IMAGE → take flexible space
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: const Color(0xFFF6F7F9),
                          alignment: Alignment.center,
                          child: Image.network(
                            Constants.imageUrl + b.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image_rounded),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
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
                ),

                // CONTENT → fixed height
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.titleSize(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "${b.price.toString()} টাকা",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w700,
                              fontSize: Responsive.priceSize(context),
                            ),
                          ),
                          const SizedBox(width: 6),
                          b.discountedPrice == 0
                              ? SizedBox()
                              : Text(
                                  b.discountedPrice.toString(),
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

                // CTA → fixed 36px
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: showCta ? 36 : 0,
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

  // Make card wider
  static double cardWidth(BuildContext ctx) =>
      isLargeScreen(ctx) ? 220 : (isMediumScreen(ctx) ? 180 : 160);

  static double titleSize(BuildContext ctx) => isSmallScreen(ctx) ? 13 : 15;
  static double priceSize(BuildContext ctx) => isSmallScreen(ctx) ? 13 : 14;
}
