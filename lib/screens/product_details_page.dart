import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final VoidCallback? onCartItemAdded; // Callback para notificar a adição ao carrinho

  ProductDetailsPage({required this.product, this.onCartItemAdded});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();

  // Restante do código...
}




class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  Future<void> _fetchCartItems() async {
    final url = Uri.parse('http://localhost:3333/cart');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Atualize a lista de itens do carrinho após adicionar um item
      setState(() {
        // Atualize os cartItems com os dados recebidos
        // cartItems = ...
      });
    } else {
      throw Exception('Erro ao buscar itens do carrinho');
    }
  }

  Future<void> _addToCart() async {
    final url = Uri.parse('http://localhost:3333/cart/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'productId': widget.product.id,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produto adicionado ao carrinho'),
          backgroundColor: Colors.green,
        ),
      );
      // Atualize a lista de itens do carrinho após adicionar um item
      await _fetchCartItems();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar produto ao carrinho'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 178, 201, 230),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 178, 201, 230),
        title: Text(widget.product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.network(
                widget.product.image,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.product.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.product.body,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Preço: \$${(widget.product.price * quantity).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _decrementQuantity,
                ),
                Text(
                  '$quantity',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _incrementQuantity,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    child: Text('Adicionar ao Carrinho'),
                  ),
                ),
                SizedBox(width: 8),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
