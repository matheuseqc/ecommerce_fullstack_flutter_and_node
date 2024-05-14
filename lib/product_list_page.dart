import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/product_card.dart';
import 'package:flutter_application_1/product_details_page.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'product.dart';



class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = _fetchProducts(); // Chama a função para buscar os produtos
  }

  Future<List<Product>> _fetchProducts() async {
    List<Product> products = [
      Product(id: 1, title: 'Camisa', body: 'Camisa de algodão', price: 39.99, image: 'imagens/camisa.png'),
      Product(id: 2, title: 'Videogame', body: 'Console de última geração', price: 499.99, image: 'imagens/video.png'),
      Product(id: 3, title: 'Tênis', body: 'Tênis esportivo', price: 79.99, image: 'imagens/tenis.png'),
      Product(id: 4, title: 'Celular', body: 'Smartphone com câmera de alta resolução', price: 699.99, image: 'imagens/celular.png'),
      Product(id: 5, title: 'Livro', body: 'Best-seller internacional', price: 19.99, image: 'imagens/livro.png'),
      Product(id: 6, title: 'Mochila', body: 'Mochila resistente para viagens', price: 49.99, image: 'imagens/mochila.png'),
      Product(id: 7, title: 'Óculos ', body: 'Óculos', price: 29.99, image: 'imagens/oculos.png'),
      Product(id: 8, title: 'Chinelo', body: 'Chinelo', price: 99.99, image: 'imagens/chinelo.png'),
      Product(id: 9, title: 'Boné', body: 'Boné', price: 199.99, image: 'imagens/bone.png'),
      Product(id: 10, title: 'Fone de ouvido', body: 'Fone de ouvido sem fio', price: 59.99, image: 'imagens/fone.png'),
    ];
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart), // Ícone de e-commerce
            SizedBox(width: 5), // Espaçamento entre o ícone e o texto
            Text('E-commerce'), // Texto do título
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else {
              return GridView.builder(
                padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailsPage(product: snapshot.data![index])),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ProductCard(product: snapshot.data![index]),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

