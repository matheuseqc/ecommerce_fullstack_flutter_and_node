import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Product>> futureFavorites;

  @override
  void initState() {
    super.initState();
    futureFavorites = fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Favoritos'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum favorito encontrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ListTile(
                  title: Text(product.title),
                  // Outras informações do produto...
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Product>> fetchFavorites() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3000/favorite'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Product> favorites = [];
      
      for (var item in responseData) {
        favorites.add(Product.fromJson(item['product']));
      }

      return favorites;
    } else {
      throw Exception('Erro ao buscar favoritos: ${response.statusCode}');
    }
  } catch (error) {
    print('Erro ao buscar favoritos: $error');
    return [];
  }
}

  Future<void> addToFavorites(int productId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/favorite'),
        body: json.encode({'productId': productId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Produto adicionado aos favoritos com sucesso
        setState(() {
          // Atualiza a lista de favoritos após adicionar o produto
          futureFavorites = fetchFavorites();
        });
      } else {
        throw Exception('Erro ao adicionar produto aos favoritos: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao adicionar produto aos favoritos: $error');
    }
  }
}