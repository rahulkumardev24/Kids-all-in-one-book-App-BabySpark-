class BookModel {
  String title;
  String image;
  BookModel({
    required this.title,
    required this.image,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      image: json['image'],
    );
  }
}
