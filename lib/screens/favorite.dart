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
  late List<Product> favoriteProducts = [];
  late List<int> favoriteProductIds = [];

  @override
  void initState() {
    super.initState();
    futureFavorites = fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 178, 201, 230),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 178, 201, 230),
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
            favoriteProducts = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return _buildProductItem(product);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white70,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                product.image ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Preço: \$${product.price?.toStringAsFixed(2) ?? ''}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Product>> fetchFavorites() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3333/favorite'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Product> favorites = [];

        for (var item in responseData) {
          favorites.add(Product.fromJson(item['product']));
        }

        // Atualiza a lista de IDs de produtos favoritos
        favoriteProductIds = favorites.map((product) => product.id!).toList();

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
      // Verifica se o produto já está na lista de favoritos
      if (favoriteProductIds.contains(productId)) {
        return; // Sai da função se o produto já estiver na lista de favoritos
      }

      final response = await http.post(
        Uri.parse('http://localhost:3333/favorite'),
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
        throw Exception(
            'Erro ao adicionar produto aos favoritos: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao adicionar produto aos favoritos: $error');
    }
  }
}
