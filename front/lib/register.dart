import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front/login.dart'; // Asegúrate de tener este archivo

class Register extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController identificacionController =
      TextEditingController();

  void showMessage(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost:5220/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombreController.text.trim(),
          'correo': correoController.text.trim().toLowerCase(),
          'password': passwordController.text.trim(),
          'identificacion': identificacionController.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage("✅ Usuario registrado correctamente");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => loging()),
        );
      } else {
        showMessage("❌ Error al registrar usuario");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre completo'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Campo requerido'
                              : null,
                ),
                TextFormField(
                  controller: correoController,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo requerido';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Correo inválido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo requerido';
                    if (value.length < 8)
                      return 'Debe tener al menos 8 caracteres';
                    return null;
                  },
                ),
                TextFormField(
                  controller: identificacionController,
                  decoration: InputDecoration(labelText: 'Identificación'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Campo requerido'
                              : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: register, child: Text('Registrar')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿Ya tiene cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => loging()),
                        );
                      },
                      child: Text('Inicie sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
