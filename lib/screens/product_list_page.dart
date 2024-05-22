import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/screens/favorite.dart';
import 'package:flutter_application_1/screens/cart_page.dart';
import 'package:flutter_application_1/screens/profile_page.dart';
import 'package:flutter_application_1/widgets/product_card.dart';
import 'package:flutter_application_1/screens/product_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductListPage extends StatefulWidget {
  final String username;

  ProductListPage({required this.username});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  int _selectedIndex = 0;
  late Future<List<Product>> futureProducts;
  late Future<List<int>> futureFavoriteProductIds;
  int _cartItemCount = 0;
  int _favoriteItemCount = 0;

  @override
  void initState() {
    super.initState();
    futureProducts = _fetchProducts();
    futureFavoriteProductIds = _fetchFavoriteProductIds();
    _updateCartItemCount();
    _updateFavoriteItemCount();
  }

  Future<List<Product>> _fetchProducts() async {
    List<Product> products = [
      Product(
          id: 1,
          title: 'Camisa',
          body: 'Camisa de algodão',
          price: 39.99,
          image: 'assets/imagens/camisa.png'),
      Product(
          id: 2,
          title: 'Videogame',
          body: 'Console de última geração',
          price: 499.99,
          image: 'assets/imagens/video.png'),
      Product(
          id: 3,
          title: 'Tênis',
          body: 'Tênis esportivo',
          price: 79.99,
          image: 'assets/imagens/tenis.png'),
      Product(
          id: 4,
          title: 'Celular',
          body: 'Smartphone com câmera de alta resolução',
          price: 699.99,
          image: 'assets/imagens/celular.png'),
      Product(
          id: 5,
          title: 'Livro',
          body: 'Best-seller internacional',
          price: 19.99,
          image: 'assets/imagens/livro.png'),
      Product(
          id: 6,
          title: 'Mochila',
          body: 'Mochila resistente para viagens',
          price: 49.99,
          image: 'assets/imagens/mochila.png'),
      Product(
          id: 7,
          title: 'Óculos',
          body: 'Óculos de sol polarizados',
          price: 29.99,
          image: 'assets/imagens/oculos.png'),
      Product(
          id: 8,
          title: 'Chinelo',
          body: 'Chinelo confortável',
          price: 19.99,
          image: 'assets/imagens/chinelo.png'),
      Product(
          id: 9,
          title: 'Boné',
          body: 'Boné estiloso',
          price: 14.99,
          image: 'assets/imagens/bone.png'),
      Product(
          id: 10,
          title: 'Fone de ouvido',
          body: 'Fone de ouvido sem fio',
          price: 59.99,
          image: 'assets/imagens/fone.png'),
    ];
    return products;
  }

  Future<List<int>> _fetchFavoriteProductIds() async {
    final response =
        await http.get(Uri.parse('http://localhost:3333/favorite'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<int> favoriteProductIds =
          data.map<int>((item) => item['productId']).toList();
      return favoriteProductIds;
    } else {
      throw Exception('Erro ao buscar favoritos');
    }
  }

  Future<List<CartItem>> _fetchCartItems() async {
    final response = await http.get(Uri.parse('http://localhost:3333/cart'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar itens do carrinho');
    }
  }

  Future<void> _updateCartItemCount() async {
    try {
      List<CartItem> cartItems = await _fetchCartItems();
      setState(() {
        _cartItemCount = cartItems.map((item) => item.product).toSet().length;
      });
    } catch (error) {
      print('Erro ao atualizar contagem de itens do carrinho: $error');
    }
  }

  Future<void> _updateFavoriteItemCount() async {
    try {
      List<int> favoriteProductIds = await _fetchFavoriteProductIds();
      setState(() {
        _favoriteItemCount = favoriteProductIds.length;
      });
    } catch (error) {
      print('Erro ao atualizar contagem de favoritos: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onCartItemAdded() {
  _updateCartItemCount(); // Função para atualizar o contador do carrinho
  }     

  void _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (error) {
      print('Erro ao fazer logout: $error');
    }
  }

Future<void> _addToCart(int productId) async {
  final url = Uri.parse('http://localhost:3333/cart/add');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'productId': productId,
      'quantity': 1, // You can adjust the quantity as needed
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produto adicionado ao carrinho'),
        backgroundColor: Colors.green,
      ),
    );
    // Chama o callback para notificar a adição ao carrinho
    _onCartItemAdded();
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
      appBar: PreferredSize(
        preferredSize: Size(100, 60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          shadowColor: Colors.black,
          flexibleSpace: Container(
            width: 300,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/imagens/logo.png',
                width: 30,
                height: 30,              ),
              SizedBox(width: 10),
              Text('E-commerce'),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritesPage()),
                    );
                  },
                ),
                if (_favoriteItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$_favoriteItemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    ).then((_) => _updateCartItemCount()); // Atualiza ao retornar
                  },
                ),
                
                    
                  
              ],
            ),
          ],
        ),
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
                    List<int> favoriteProductIds =
                        snapshot.data![1] as List<int>;

                    return GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        bool isFavorite =
                            favoriteProductIds.contains(products[index].id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                        product: products[index],
                                        // Passa o callback para notificar a adição ao carrinho
                                        onCartItemAdded: () {
                                          _updateCartItemCount(); // Atualiza o contador do carrinho
                                        },
                                      ),
                                    ),
                                  
                            ).then((_) {
                              _updateCartItemCount();
                              _updateFavoriteItemCount();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: ProductCard(
                              product: products[index],
                              isFavorite: isFavorite,
                              onFavoriteTap: () {
                                setState(() {
                                  if (isFavorite) {
                                    favoriteProductIds.remove(products[index].id);
                                  } else {
                                    favoriteProductIds.add(products[index].id);
                                  }
                                });
                                _updateFavoriteItemCount();
                              },
                              onAddToCart: () {
                                _addToCart(products[index].id);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            : ProfilePage(
                username: widget.username,
                onLogout: _logout,
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}

