import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart'; // Importe a classe Product

import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart'; // Importe a classe Product

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1; // Quantidade inicial do produto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: ${widget.product.title}'),
            Text('Description: ${widget.product.body}'),
            Text('Price: \$${widget.product.price.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para adicionar ao carrinho
              },
              child: Text('Adicionar ao Carrinho'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para comprar agora
              },
              child: Text('Comprar Agora'),
            ),
          ],
        ),
      ),
    );
  }
}

