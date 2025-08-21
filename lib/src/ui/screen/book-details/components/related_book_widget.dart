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
    final book = widget.book;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        width: 160,
        height: 120,
        margin: const EdgeInsets.only(left: 20, right: 8, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Image and Top Badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        Constants.imageUrl + book.image,
                        // height: Responsive.isSmallScreen(context)
                        //     ? MediaQuery.of(context).size.height * 0.14
                        //     : MediaQuery.of(context).size.height * 0.12,
                        width: double.infinity,
                        height: Responsive.isSmallScreen(context) ? 110 : 160,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                    // Discount Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '১৫% ছাড়',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    // Wishlist Icon
                    const Positioned(
                      top: 2,
                      right: 8,
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                // Book Details
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'মুনজেরিন শহীদ',
                        style: TextStyle(color: Colors.black54, fontSize: 8),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            book.discountedPrice.toString() ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            book.price.toString() ?? "",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade600,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Add to Cart Button (appears on hover)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: isHovered ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: () {
                    cartController.addToCart(book);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Add To Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
