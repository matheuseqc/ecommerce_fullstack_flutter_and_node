import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartItem>> futureCartItems;

  @override
  void initState() {
    super.initState();
    futureCartItems = _fetchCartItems();
  }

  Future<List<CartItem>> _fetchCartItems() async {
    final url = Uri.parse('http://localhost:3000/cart');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar itens do carrinho');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: FutureBuilder<List<CartItem>>(
        future: futureCartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Seu carrinho está vazio'));
          } else {
            // Agrupando os itens do carrinho por produto
            Map<int, CartItem> groupedItems = {};
            snapshot.data!.forEach((item) {
              if (groupedItems.containsKey(item.product.id)) {
                groupedItems[item.product.id]!.quantity += item.quantity;
              } else {
                groupedItems[item.product.id] = item;
              }
            });

            // Calculando o total do carrinho
            double total = groupedItems.values
                .map((item) => item.product.price * item.quantity)
                .reduce((value, element) => value + element);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedItems.length,
                    itemBuilder: (context, index) {
                      final item = groupedItems.values.toList()[index];
                      return ListTile(
                        leading: Image.network(item.product.image),
                        title: Text(item.product.title),
                        subtitle: Text('Quantidade: ${item.quantity}'),
                        trailing: Text(
                            'Total: \$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
               
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Text('Comprar Agora'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}