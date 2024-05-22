import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../screens/product_details_page.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    required Null Function() onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: widget.product),
          ),
        );
      },
      child: Card(
        shadowColor: Colors.black,
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: _isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
            Image.network(
              widget.product.image!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              widget.product.title!,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Preço: \$${widget.product.price!.toStringAsFixed(2)}',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    try {
      final response = await (_isFavorite
          ? http.post(
              Uri.parse('http://localhost:3333/favorite/add'),
              body: jsonEncode({'productId': widget.product.id}),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            )
          : http.delete(
              Uri.parse('http://localhost:3333/favorite/remove'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({'productId': widget.product.id}),
            ));

      if ((response.statusCode != 201 && _isFavorite) ||
          (response.statusCode != 200 && !_isFavorite)) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        throw Exception(
            'Erro ao adicionar/remover favorito: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
      print('Erro ao adicionar/remover favorito: $error');
    }

    // Call the provided callback to update the parent state
    widget.onFavoriteTap();
  }
}
