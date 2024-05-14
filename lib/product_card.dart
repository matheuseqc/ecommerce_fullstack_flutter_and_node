// product_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            product.image, // Utiliza a imagem do produto
            width: 110, // Define a largura da imagem
            height: 100, // Define a altura da imagem
            fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
          ),
          SizedBox(height: 8),
          Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Preço: \$${product.price.toStringAsFixed(2)}', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
