class BannerModel {
  final int id;
  final String title;
  final String image;
  final String description;
  final String link;
  final bool isActive;
  List<dynamic> images;

  BannerModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.link,
    required this.isActive,
    required this.images,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      link: json['link'],
      isActive: json['is_active'],
      images: List<dynamic>.from(json["images"].map((x) => x)),
    );
  }
}
