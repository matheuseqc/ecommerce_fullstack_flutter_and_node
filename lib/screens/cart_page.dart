import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
    final url = Uri.parse('http://localhost:3333/cart');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar itens do carrinho');
    }
  }

  Future<void> _removeCartItem(int cartItemId) async {
    try {
      final url = Uri.parse('http://localhost:3333/cart/$cartItemId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          futureCartItems = _fetchCartItems();
        });
      } else {
        throw Exception('Erro ao remover item do carrinho');
      }
    } catch (error) {
      _showErrorDialog('Erro ao remover item do carrinho', error.toString());
    }
  }

  Future<void> _updateCartItemQuantity(int cartItemId, int newQuantity) async {
    try {
      final url = Uri.parse('http://localhost:3333/update');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cartItemId': cartItemId, 'quantity': newQuantity}),
      );

      if (response.statusCode == 200) {
        setState(() {
          futureCartItems = _fetchCartItems();
        });
      } else {
        throw Exception('Erro ao atualizar quantidade do item no carrinho');
      }
    } catch (error) {
      _showErrorDialog('Erro ao atualizar quantidade do item no carrinho', error.toString());
    }
  }

  Future<void> _createPayment() async {
    final url = Uri.parse('http://localhost:3333/create');
    try {
      final List<CartItem> cartItems = await futureCartItems;
      double total = 0.0;
      for (final CartItem item in cartItems) {
        total += item.product.price * item.quantity;
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': 'Produtos carrinho',
          'quantity': 1,
          'unit_price': total
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty && data['checkoutURL'] != null) {
          final checkoutURL = data['checkoutURL'];
          _launchCheckout(checkoutURL);
        } else {
          throw Exception('URL de checkout não encontrada na resposta da API');
        }
      } else {
        throw Exception('Erro ao criar pagamento: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog('Erro ao criar pagamento', error.toString());
    }
  }

  Future<void> _launchCheckout(String checkoutURL) async {
    if (await canLaunch(checkoutURL)) {
      await launch(checkoutURL);
    } else {
      throw Exception('Não foi possível abrir o link de checkout: $checkoutURL');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 178, 201, 230),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 178, 201, 230),
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
                          return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/imagens/cart.png',
                          width: 100, 
                          height: 100,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'SEU CARRINHO ESTÁ VAZIO!',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
          } else {
            Map<int, CartItem> groupedItems = {};
            snapshot.data!.forEach((item) {
              if (groupedItems.containsKey(item.product.id)) {
                groupedItems[item.product.id] = CartItem(
                  id: item.id,
                  product: item.product,
                  quantity: groupedItems[item.product.id]!.quantity + item.quantity,
                );
              } else {
                groupedItems[item.product.id] = item;
              }
            });

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
                      return Card(
                        color: Colors.white70,
                        margin: EdgeInsets.all(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Image.network(item.product.image, width: 50, height: 50),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.title),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: item.quantity > 1
                                              ? () {
                                                  _updateCartItemQuantity(item.id, item.quantity - 1);
                                                }
                                              : null,
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            _updateCartItemQuantity(item.id, item.quantity + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total: \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red,),
                                    onPressed: () {
                                      _removeCartItem(item.id).then((_) {
                                        setState(() {
                                          futureCartItems = _fetchCartItems();
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _createPayment();
                        },
                        child: Text('Concluir Pedido'),
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
