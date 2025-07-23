import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/book-controller/bookdetails_controller.dart';
import '../../../core/models/book-details/book-details.dart';

class BookDetailsScreen extends StatefulWidget {
  final String bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final BookDetailsController controller = Get.put(BookDetailsController());

  @override
  void initState() {
    super.initState();
    controller.fetchBookDetailsData(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('বইয়ের বিস্তারিত')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookDetails.value == null) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final BookDetail book = controller.bookDetails.value!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "http://192.168.68.103:8000${book.image}",
                    height: 200,
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
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Author
              Text(
                'লেখক: ${book.editor ?? "অজানা"}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 8),

              // Price
              Text(
                'মূল্য: ৳${book.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    book.description ?? 'কোনো বিবরণ নেই।',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Cart'),
                      onPressed: () {
                        // Add to cart logic
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Wishlist'),
                      onPressed: () {
                        // Add to wishlist
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
