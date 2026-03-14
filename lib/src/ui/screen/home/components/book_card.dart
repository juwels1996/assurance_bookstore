import 'package:assurance_bookstore/src/core/models/home/home_page_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/cart-controller/cart_controller.dart';
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
          // boxShadow: [
          //   BoxShadow(
          //     color: _hover ? Colors.black.withOpacity(0.06) : Colors.black12,
          //     blurRadius: _hover ? 16 : 10,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => Get.toNamed('/book/${b.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE → take flexible space
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AnimatedScale(
                          scale: _hover ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: SizedBox(
                            height: 200, // force bigger image height
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: b.image,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),

                          //
                          // Image.network(
                          //   Constants.imageUrl + b.image,
                          //   fit: BoxFit.contain,
                          // ),
                        ),
                      ),
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
                          child: Text(
                            (b.initialPrice != null && b.initialPrice > 0)
                                ? '${(((b.initialPrice - b.price) / b.initialPrice) * 100).round()}% ছাড়'
                                : '0% ছাড়',
                            style: const TextStyle(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "NotoSerif",
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
                              fontFamily: "NotoSans",
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w700,
                              fontSize: Responsive.priceSize(context),
                            ),
                          ),
                          const SizedBox(width: 6),
                          b.initialPrice == 0
                              ? SizedBox()
                              : Text(
                                  b.initialPrice.toString(),
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
                              color: Colors.redAccent,
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
      isLargeScreen(ctx) ? 280 : (isMediumScreen(ctx) ? 290 : 250);

  static double titleSize(BuildContext ctx) => isSmallScreen(ctx) ? 13 : 15;
  static double priceSize(BuildContext ctx) => isSmallScreen(ctx) ? 13 : 14;
}
