import 'dart:convert';

List<HomePageData> homePageDataFromJson(String str) => List<HomePageData>.from(
  json.decode(str).map((x) => HomePageData.fromJson(x)),
);

String homePageDataToJson(List<HomePageData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
  };
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

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "slug": slug,
    "books": List<dynamic>.from(books.map((x) => x.toJson())),
  };
}

class Book {
  int id;
  String title;
  String image;
  int category;
  int subcategory;
  String description;
  bool isActive;
  DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.subcategory,
    required this.description,
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
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "category": category,
    "subcategory": subcategory,
    "description": description,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
  };
}
