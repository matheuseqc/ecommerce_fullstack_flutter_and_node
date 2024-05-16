import 'package:flutter/material.dart';
import 'product_list_page.dart';

class LoginWithCredentialsPage extends StatefulWidget {
  @override
  _LoginWithCredentialsPageState createState() =>
      _LoginWithCredentialsPageState();
}

class _LoginWithCredentialsPageState extends State<LoginWithCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

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
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          //border: OutlineInputBorder(),
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
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Senha',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          //border: OutlineInputBorder(),
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
                        obscureText: _obscureText,
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
                          // Implementar lógica de login
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListPage(),
                            ),
                          );
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
