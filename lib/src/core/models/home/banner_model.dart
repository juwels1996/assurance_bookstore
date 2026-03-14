import 'home_page_data.dart';

class BannerModel {
  final int id;
  final String title;
  final String image;
  final String description;
  final String link;
  final bool isActive;
  final List<dynamic> images;
  final List<Book> comboBooks;
  final double comboPrice;

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
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      isActive: json['is_active'] ?? false,
      images: List<dynamic>.from(json['images'] ?? []),
      comboBooks:
          (json['combo_books'] as List<dynamic>?)
              ?.map((b) => Book.fromJson(b))
              .toList() ??
          [],
      comboPrice: (json['combo_price'] as num?)?.toDouble() ?? 0,
    );
  }
}
