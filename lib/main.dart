import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/product_list_page.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'E-commerce App',
    home: ProductListPage(),
  ));
}