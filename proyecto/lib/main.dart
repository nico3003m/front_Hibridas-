import 'package:flutter/material.dart';
import 'screens/list_cliente_screen.dart' show ListClienteScreen;
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/clientes': (context) => ListClienteScreen(),
      },
    );
  }
}
