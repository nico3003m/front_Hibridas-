import 'package:flutter/material.dart';
import 'package:front/login.dart';
import 'register.dart'; // Importamos la pantalla de registro

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      initialRoute: '/',
      routes: {
        '/': (context) => loging(), // ← Agregado
        '/login': (context) => loging(),
        '/register': (context) => Register(),
      },
    );
  }
}
