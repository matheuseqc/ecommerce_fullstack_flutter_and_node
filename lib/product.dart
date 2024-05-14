// product.dart

class Product {
  final int id;
  final String title;
  final String body;
  final double price;
  final String image; // Nova propriedade para a imagem do produto

  Product({required this.id, required this.title, required this.body, required this.price, required this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'], // Pega a imagem do JSON
    );
  }
}
