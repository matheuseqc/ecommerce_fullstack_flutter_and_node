import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/product_list_page.dart';
import 'package:http/http.dart' as http;
import 'dart:math';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListPage(), // Define a tela de login como a inicial
    );
  }
}
