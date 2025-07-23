class BannerModel {
  final int id;
  final String title;
  final String image;
  final String description;
  final String link;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.link,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      link: json['link'],
      isActive: json['is_active'],
    );
  }
}
