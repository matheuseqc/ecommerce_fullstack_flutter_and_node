import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final dynamic product;

  const CartPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho de Compras'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Seu carrinho está vazio'),
      ),
    );
  }
}
