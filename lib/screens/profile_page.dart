import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  ProfilePage({required this.username, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false, // Desabilita o botão de voltar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Seja bem-vindo, $username!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onLogout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

