class BannerModel {
  final int id;
  final String title;
  final String image;
  final String description;
  final String link;
  final bool isActive;
  List<dynamic> images;
  List<BookModel> comboBooks; // New field for combo
  double comboPrice; // New field for total combo price

  BannerModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.link,
    required this.isActive,
    required this.images,
    this.comboBooks = const [],
    this.comboPrice = 0,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      link: json['link'],
      isActive: json['is_active'],
      images: List<dynamic>.from(json['images'].map((x) => x)),
      comboBooks:
          (json['combo_books'] as List<dynamic>?)
              ?.map((b) => BookModel.fromJson(b))
              .toList() ??
          [],
      comboPrice: (json['combo_price'] as num?)?.toDouble() ?? 0,
    );
  }
}

class BookModel {
  final int id;
  final String title;
  final String image;
  final double price;
  final double discountedPrice;

  BookModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.discountedPrice,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num).toDouble(),
    );
  }
}
