class Product {
  final int id;
  final String title;
  final String body;
  final double price;
  final String image;

  Product({required this.id, required this.title, required this.body, required this.price, required this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
    );
  }
}
