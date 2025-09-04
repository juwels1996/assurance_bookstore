import 'dart:convert';

List<HomePageData> homePageDataFromJson(String str) => List<HomePageData>.from(
  json.decode(str).map((x) => HomePageData.fromJson(x)),
);

class HomePageData {
  int id;
  String name;
  String slug;
  List<Subcategory> subcategories;

  HomePageData({
    required this.id,
    required this.name,
    required this.slug,
    required this.subcategories,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) => HomePageData(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    subcategories: List<Subcategory>.from(
      json["subcategories"].map((x) => Subcategory.fromJson(x)),
    ),
  );
}

class Subcategory {
  int id;
  String name;
  int category;
  String slug;
  List<Book> books;

  Subcategory({
    required this.id,
    required this.name,
    required this.category,
    required this.slug,
    required this.books,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json["id"],
    name: json["name"],
    category: json["category"],
    slug: json["slug"],
    books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
  );
}

class Book {
  int id;
  String title;
  String image;
  int category;
  int subcategory;
  String description;
  String? edition;
  String? publisher;
  String? editor;
  int price;
  int initialPrice;
  int discountedPrice;
  int deliveryCharge;
  int pages;
  String country;
  String language;
  int quantityAvailable;
  String? previewPdf;
  bool isActive;
  DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.edition,
    required this.publisher,
    required this.editor,
    required this.price,
    required this.initialPrice,
    required this.discountedPrice,
    required this.deliveryCharge,
    required this.pages,
    required this.country,
    required this.language,
    required this.quantityAvailable,
    required this.previewPdf,
    required this.isActive,
    required this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    category: json["category"],
    subcategory: json["subcategory"],
    description: json["description"],
    edition: json["edition"],
    publisher: json["publisher"],
    editor: json["editor"],
    price: json["price"],
    initialPrice: json["initial_price"],
    discountedPrice: json["discounted_price"],
    deliveryCharge: json["delivery_charge"],
    pages: json["pages"],
    country: json["country"],
    language: json["language"],
    quantityAvailable: json["quantity_available"],
    previewPdf: json["preview_pdf"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
  );
}
