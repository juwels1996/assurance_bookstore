class BookDetail {
  int id;
  String? title;
  String? image;
  String? editor;
  String? publisher;
  String? edition;
  int? pages;
  String? country;
  String? language;
  int? price;
  int? discountedPrice;
  int? discountPercent;
  bool? isAvailable;
  int? quantityAvailable;
  String? previewPdfUrl;
  String? description;
  List<String>? features;
  List<RelatedBook>? relatedBooks;

  BookDetail({
    required this.id,
    this.title,
    this.image,
    this.editor,
    this.publisher,
    this.edition,
    this.pages,
    this.country,
    this.language,
    this.price,
    this.discountedPrice,
    this.discountPercent,
    this.isAvailable,
    this.quantityAvailable,
    this.previewPdfUrl,
    this.description,
    this.features,
    this.relatedBooks,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
    id: json['id'] ?? "",
    title: json['title'] ?? "",
    image: json['image'] ?? "",
    editor: json['editor'] ?? "",
    publisher: json['publisher'] ?? "",
    edition: json['edition'] ?? "",
    pages: json['pages'] ?? "",
    country: json['country'] ?? "",
    language: json['language'] ?? "",
    price: json['price'] ?? "",
    discountedPrice: json['discounted_price'] ?? "",
    discountPercent: json['discount_percent'] ?? "",
    isAvailable: json['is_available'] ?? false,
    quantityAvailable: json['quantity_available'] ?? "",
    previewPdfUrl: json['preview_pdf_url'] ?? "",
    description: json['description'] ?? "",
    features: json['features'] != null
        ? List<String>.from(json['features'])
        : [],

    relatedBooks: json['related_books'] != null
        ? List<RelatedBook>.from(
            json['related_books'].map((x) => RelatedBook.fromJson(x)),
          )
        : [],
  );
}

class RelatedBook {
  int id;
  String title;
  String image;
  int price;
  int discountedPrice;

  RelatedBook({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.discountedPrice,
  });

  factory RelatedBook.fromJson(Map<String, dynamic> json) => RelatedBook(
    id: json['id'],
    title: json['title'],
    image: json['image'],
    price: json['price'],
    discountedPrice: json['discounted_price'],
  );
}
