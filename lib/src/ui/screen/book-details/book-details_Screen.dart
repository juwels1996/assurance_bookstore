import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui_web' as ui;
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
      controller.fetchBookDetailsData(bookId);
    });
  }

  void _openPdfDialog(BuildContext context, String pdfUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: PdfViewer.uri(Uri.parse(pdfUrl)),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller.fetchBookDetailsData(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '📚 বইয়ের বিস্তারিত',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          Obx(() {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Get.to(() => CartScreen()),
                ),
                if (cartController.totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Book Cover + Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.image.toString(),
                      height: 200,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Book Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "by ${book.editor ?? "Unknown"}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "৳ ${book.price}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Book Specs
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      buildSpecRow("প্রকাশনী", "Assurance Publications"),
                      buildSpecRow("পৃষ্ঠা সংখ্যা", "${book.pages ?? "N/A"}"),
                      buildSpecRow("সংস্করণ", "${book.edition ?? "N/A"}"),
                      buildSpecRow("ভাষা", book.language ?? "বাংলা"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "বিবরণ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ReadMoreText(
                book.description ?? 'কোনো বিবরণ নেই।',
                trimMode: TrimMode.Line,
                trimLines: 4,
                colorClickableText: Colors.deepPurple,
                trimCollapsedText: 'আরও পড়ুন',
                trimExpandedText: 'কম দেখান',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: Responsive.isSmallScreen(context)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                crossAxisAlignment: Responsive.isSmallScreen(context)
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  book.quantityAvailable == 0
                      ? SizedBox()
                      : GestureDetector(
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
                  book.previewPdfUrl != null && book.previewPdfUrl!.isNotEmpty
                      ? OutlinedButton.icon(
                          onPressed: () {
                            print("${book.previewPdfUrl}");
                            print(
                              "https://backend.assurancepublication.com/${book.previewPdfUrl}",
                            );
                            _openPdfDialog(context, "${book.previewPdfUrl}");
                          },
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                          label: const Text("একটু পড়ে দেখুন"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(height: 15),

              book.quantityAvailable == 0
                  ? Container(child: Text("Out Of Stock"))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          int quantity = cartController.getQuantity(book);

                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6FA),
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Decrement Button
                                GestureDetector(
                                  onTap: () =>
                                      cartController.removeFromCart(book),
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
                              // Clear existing cart items
                              cartController.cartItems.clear();

                              // Add only the selected book
                              cartController.addToCart(book);
                            });

                            // Navigate to cart screen
                            Get.to(() => CartScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Colors.green.shade400, // Buy Now button color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
              const SizedBox(height: 30),

              // 🔹 Related Books
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "সম্পর্কিত বই",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
              const Divider(),
              SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: book.relatedBooks?.length ?? 0,
                  itemBuilder: (context, bookIndex) {
                    return GestureDetector(
                      onTap: () => updateBookDetails(
                        book.relatedBooks![bookIndex].id.toString(),
                      ),
                      child: BookDetailsCard(
                        book: book.relatedBooks![bookIndex],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
