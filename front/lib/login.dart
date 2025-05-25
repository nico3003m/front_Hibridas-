import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(loging());
}

class loging extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'login App',
      home: RegisterScreen(), // Asegúrate que esta sea la pantalla inicial
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  // Mostrar mensajes tipo SnackBar
  void showMessage(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  // Función para registrar al usuario
  void register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.20.30:5000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'password': passController.text.trim(),
          'correo': correoController.text.trim().toLowerCase(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage("✅ Usuario ingreso correctamente  ");
        Navigator.pop(context);
      } else {
        showMessage("❌ Error al ingresar credenciales invalidas  ");
      }
    }
  }

  // Interfaz gráfica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Llave para validar el formulario
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Correo electrónico
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
                // Contraseña
                TextFormField(
                  controller: passController,
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
                SizedBox(height: 20),
                // Botón de registro
                ElevatedButton(
                  onPressed: register,
                  child: Text('Iniciar Sesion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
