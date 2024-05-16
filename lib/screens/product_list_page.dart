import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/favorite.dart';
import 'package:flutter_application_1/screens/cart_page.dart';
import 'package:flutter_application_1/screens/profile_page.dart';
import 'package:flutter_application_1/widgets/product_card.dart';
import 'package:flutter_application_1/screens/product_details_page.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../models/product.dart';


class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  int _selectedIndex = 0;
  late Future<List<Product>> futureProducts;
  late Future<List<int>> futureFavoriteProductIds;

  @override
  void initState() {
    super.initState();
    futureProducts = _fetchProducts();
    futureFavoriteProductIds = _fetchFavoriteProductIds();
  }

  Future<List<Product>> _fetchProducts() async {
    List<Product> products = [
      Product(id: 1, title: 'Camisa', body: 'Camisa de algodão', price: 39.99, image: 'assets/imagens/camisa.png'),
      Product(id: 2, title: 'Videogame', body: 'Console de última geração', price: 499.99, image: 'assets/imagens/video.png'),
      Product(id: 3, title: 'Tênis', body: 'Tênis esportivo', price: 79.99, image: 'assets/imagens/tenis.png'),
      Product(id: 4, title: 'Celular', body: 'Smartphone com câmera de alta resolução', price: 699.99, image: 'assets/imagens/celular.png'),
      Product(id: 5, title: 'Livro', body: 'Best-seller internacional', price: 19.99, image: 'assets/imagens/livro.png'),
      Product(id: 6, title: 'Mochila', body: 'Mochila resistente para viagens', price: 49.99, image: 'assets/imagens/mochila.png'),
      Product(id: 7, title: 'Óculos', body: 'Óculos de sol polarizados', price: 29.99, image: 'assets/imagens/oculos.png'),
      Product(id: 8, title: 'Chinelo', body: 'Chinelo confortável', price: 19.99, image: 'assets/imagens/chinelo.png'),
      Product(id: 9, title: 'Boné', body: 'Boné estiloso', price: 14.99, image: 'assets/imagens/bone.png'),
      Product(id: 10, title: 'Fone de ouvido', body: 'Fone de ouvido sem fio', price: 59.99, image: 'assets/imagens/fone.png'),
    ];
    return products;
  }

  Future<List<int>> _fetchFavoriteProductIds() async {
    final response = await http.get(Uri.parse('http://localhost:3000/favorite'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<int> favoriteProductIds = data.map<int>((item) => item['productId']).toList();
      return favoriteProductIds;
    } else {
      throw Exception('Erro ao buscar favoritos');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imagens/logo.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text('E-commerce'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _selectedIndex == 0
            ? FutureBuilder<List<dynamic>>(
                future: Future.wait([futureProducts, futureFavoriteProductIds]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    List<Product> products = snapshot.data![0] as List<Product>;
                    List<int> favoriteProductIds = snapshot.data![1] as List<int>;

                    return GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        bool isFavorite = favoriteProductIds.contains(products[index].id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(product: products[index]),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: ProductCard(product: products[index], isFavorite: isFavorite),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            : ProfilePage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
