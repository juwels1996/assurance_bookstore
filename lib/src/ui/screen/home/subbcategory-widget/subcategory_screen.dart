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
      appBar: AppBar(
        title: Text(widget.subcategoryName),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
          ? const Center(child: Text('No books available'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Category Info Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.subcategoryName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${books.length} books available",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Sort & Filter Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Books",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            // TODO: sort logic
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "latest",
                              child: Text("Latest"),
                            ),
                            const PopupMenuItem(
                              value: "low_to_high",
                              child: Text("Price: Low to High"),
                            ),
                            const PopupMenuItem(
                              value: "high_to_low",
                              child: Text("Price: High to Low"),
                            ),
                          ],
                          child: const Icon(Icons.sort),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Books Grid/List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isSmallScreen(context)
                            ? 2
                            : 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return BookCard(book: books[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
