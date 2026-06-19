import 'package:assurance_bookstore/src/core/constants/constants.dart';
import 'package:assurance_bookstore/src/ui/screen/book-details/book-details_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/home/home_controller.dart';

class SearchResultScreen extends StatelessWidget {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (homeController.books.isEmpty) {
          return Center(child: Text('No books found.'));
        }

        return ListView.builder(
          itemCount: homeController.books.length,
          itemBuilder: (context, index) {
            final book = homeController.books[index];
            return ListTile(
              title: Image.network(
                "${Constants.imageUrl + book.image}",
                height: 70,
              ),
              subtitle: Text(book.title),
              onTap: () {
                Get.to(BookDetailsScreen(bookId: book.id.toString()));
              },
            );
          },
        );
      }),
    );
  }
}
