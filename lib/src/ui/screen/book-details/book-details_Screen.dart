import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/ui/screen/home/components/book_card.dart'
    hide Responsive;
import 'package:assurance_bookstore/src/ui/widgets/responsive.dart'
    hide Responsive;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'dart:html' as html;
import '../../../core/constants/constants.dart';
import '../../../core/controllers/book-controller/bookdetails_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/models/book-details/book-details.dart';
import '../cart-screen/cart_screen.dart';
import 'components/related_book_widget.dart';

class BookDetailsScreen extends StatefulWidget {
  final String bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final BookDetailsController controller = Get.put(BookDetailsController());
  final CartController cartController = Get.find();

  void updateBookDetails(String bookId) {
    setState(() {
      controller.fetchBookDetailsData(
        bookId,
      ); // Fetch new book data based on selected related book
    });
  }

  @override
  void initState() {
    super.initState();
    controller.fetchBookDetailsData(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        title: Text('বইয়ের বিস্তারিত'),
        actions: [
          Obx(() {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Get.to(() => CartScreen()); // Navigate to cart screen
                  },
                ),
                if (cartController.totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Obx(
                        () => Text(
                          '${cartController.totalItems}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookDetails.value == null) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final BookDetail book = controller.bookDetails.value!;

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: Responsive.isSmallScreen(context)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                // Book Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      Constants.imageUrl + book.image.toString(),
                      height: Responsive.isSmallScreen(context) ? 150 : 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  book.title ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    // fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
                Text(
                  book.price.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Author
                const SizedBox(height: 8),

                // Price
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'প্রকাশনী :',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' Assurance Publicatios ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Description
                ReadMoreText(
                  book.description ?? 'কোনো বিবরণ নেই।',
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  colorClickableText: Colors.pink,
                  trimCollapsedText: '...Show more',
                  style: context.labelMedium!.copyWith(
                    fontFamily: "NotoSans",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  trimExpandedText: '...Show less',
                  moreStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: Responsive.isSmallScreen(context)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  crossAxisAlignment: Responsive.isSmallScreen(context)
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          cartController.addToCart(book);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey, // Button background
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Icon container with its own border and background
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.redAccent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 15),
                    book.previewPdfUrl!.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              html.window.open(
                                Constants.imageUrl +
                                    book.previewPdfUrl.toString(),
                                '_blank',
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'একটু পড়ে দেখুন',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'No Pdf Available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 15),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      int quantity = cartController.getQuantity(book);

                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF5F6FA,
                          ), // light background like screenshot
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrement Button
                            GestureDetector(
                              onTap: () => cartController.removeFromCart(book),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.red, // Light gray
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                ),
                                child: const Icon(Icons.remove, size: 18),
                              ),
                            ),

                            // Quantity Text
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              color: Colors.white,
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // Increment Button
                            GestureDetector(
                              onTap: () => cartController.addToCart(book),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                                child: const Icon(Icons.add, size: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Add the book to cart
                          cartController.addToCart(book);
                        });

                        // Navigate to Cart/Checkout screen
                        Get.to(() => CartScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade400, // Buy Now button color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon container with its own border and background
                            const SizedBox(width: 8),
                            const Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50),

                Text(
                  "Related Books",
                  style: context.labelMedium!.copyWith(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),

                SizedBox(
                  height: Responsive.isSmallScreen(context) ? 190 : 292,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: book.relatedBooks?.length,
                    itemBuilder: (context, bookIndex) {
                      return GestureDetector(
                        onTap: () {
                          // Update the book details when a related book is tapped
                          updateBookDetails(
                            book.relatedBooks![bookIndex].id.toString(),
                          );
                        },
                        child: BookDetailsCard(
                          book: book.relatedBooks![bookIndex],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
