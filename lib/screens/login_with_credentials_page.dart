import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile_page.dart';
import 'package:http/http.dart' as http;
import 'product_list_page.dart'; // Importe sua página de destino após o login

class LoginWithCredentialsPage extends StatefulWidget {
  @override
  _LoginWithCredentialsPageState createState() =>
      _LoginWithCredentialsPageState();
}

class _LoginWithCredentialsPageState extends State<LoginWithCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

Future<void> _login() async {
  final String email = _emailController.text;
  final String password = _passwordController.text;

  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login bem-sucedido, recupera as informações do usuário
      final userData = jsonDecode(response.body);
      final String username = userData['user']['username'];

      // Navega para a tela de perfil, passando o nome de usuário
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListPage(username: username),
        ),
      );
    } else {
      // Erro ao fazer login
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro ao fazer login'),
            content: Text('Credenciais inválidas. Tente novamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    print('Erro ao fazer login: $error');
    // Trate outros erros aqui, se necessário
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 173, 112, 184),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
            width: 400,
            height: 500,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/imagens/login.png',
                    width: 350,
                    height: 250,
                  ),
                  SizedBox(
                    width: 290,
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 290,
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Senha',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              color: Colors.black,
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 290,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login(); // Chama a função de login
                        }
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
