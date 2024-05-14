import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required product});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Seu carrinho está vazio'),
      ),
    );
  }
}