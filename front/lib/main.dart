import 'package:flutter/material.dart';
import 'package:front/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro App',
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
      //El correo se deja en miniscula para que el backend no tenga problema
      final response = await http.post(
        Uri.parse('http://192.168.20.30:5000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': userController.text.trim(),
          'password': passController.text.trim(),
          'nombre': nombreController.text.trim(),
          'celular': celularController.text.trim(),
          'correo': correoController.text.trim().toLowerCase(),
          'direccion': direccionController.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage("✅ Usuario registrado correctamente  ");
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => loging()),
        );
      } else {
        showMessage("❌ Error al registrar usuario  ");
      }
    }
  }

  // Interfaz gráfica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Llave para validar el formulario
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Username
                TextFormField(
                  controller: userController,
                  decoration: InputDecoration(labelText: 'Usuario'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Campo requerido'
                              : null,
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
                // Nombre completo
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre completo'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Campo requerido'
                              : null,
                ),
                // Teléfono
                TextFormField(
                  controller: celularController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo requerido';
                    if (!RegExp(r'^\d{7,15}$').hasMatch(value))
                      return 'Debe ser un número válido';
                    return null;
                  },
                ),
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
                // Direccion
                TextFormField(
                  controller: direccionController,
                  decoration: InputDecoration(
                    labelText: 'direccion de domicilio',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Campo requerido'
                              : null,
                ),
                SizedBox(height: 20),
                // Botón de registro
                ElevatedButton(onPressed: register, child: Text('Registrar')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿Ya tiene cuenta?"),
                    TextButton(
                      onPressed: () {
                        // Aquí navegas a la pantalla de inicio de sesión
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => loging()),
                        ); // o usa MaterialPageRoute
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
