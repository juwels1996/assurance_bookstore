import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/home/home_page_data.dart';
import '../../../widgets/responsive.dart';
import '../components/book_card.dart' hide Responsive;

class SubcategoryScreen extends StatefulWidget {
  final String subcategoryId;
  final String subcategoryName;

  const SubcategoryScreen({
    Key? key,
    required this.subcategoryId,
    required this.subcategoryName,
  }) : super(key: key);

  @override
  _SubcategoryScreenState createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  bool isLoading = true;
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooksForSubcategory();
  }

  // Fetch books based on selected subcategory
  Future<void> fetchBooksForSubcategory() async {
    final response = await http.get(
      Uri.parse(
        '${Constants.baseUrl}books/subcategory/${widget.subcategoryId}/',
      ),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        books = List<Book>.from(data.map((item) => Book.fromJson(item)));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Failed to load books");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subcategoryName)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : books.isEmpty
          ? Center(child: Text('No books available'))
          : SizedBox(
              height: Responsive.isSmallScreen(context) ? 200 : 292,
              child: ListView.builder(
                padding: const EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCard(book: books[index]);
                },
              ),
            ),
    );
  }
}

// Book Model
