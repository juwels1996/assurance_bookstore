import 'package:assurance_bookstore/src/core/constants/constants.dart';
import 'package:assurance_bookstore/src/ui/screen/book-details/book-details_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../home_page.dart';

class SearchResultScreen extends StatelessWidget {
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
