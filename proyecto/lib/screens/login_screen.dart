import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- Agrega esta línea
import '../services/api_service.dart';
import '../models/usuario.dart';
import 'list_cliente_screen.dart';
import 'register_usuario_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    Usuario? user = await ApiService.login(
      _correoController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _loading = false;
    });

    if (user != null) {
      // ✅ Guarda datos del usuario en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usuarioId', user.id!); // Para filtrar clientes
      await prefs.setString(
        'nombreUsuario',
        user.nombre,
      ); // Para mostrar en la pantalla
      print('Nombre del usuario guardado: ${user.nombre}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ListClienteScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Credenciales inválidas. Intenta de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/compensar.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                  TextFormField(
                    controller: _correoController,
                    decoration: InputDecoration(labelText: 'Correo'),
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (value) => value!.isEmpty ? 'Ingrese su correo' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      if (value.length < 8) {
                        return 'La contraseña debe tener al menos 8 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _login,
                        child: Text('Ingresar'),
                      ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterUsuarioScreen(),
                        ),
                      );
                    },
                    child: Text('¿No tienes cuenta? Regístrate aquí'),
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
