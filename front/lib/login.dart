import 'package:flutter/material.dart'; // Widgets de Flutter
import 'package:front/main.dart'; // Tu archivo principal (puedes modificar según organización)
import 'package:front/home.dart'; // Pantalla Home después del login
import 'package:http/http.dart' as http; // Para peticiones HTTP
import 'dart:convert'; // Para convertir JSON

void main() {
  runApp(loging()); // Ejecuta la clase `loging` al iniciar
}


class loging extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      title: 'login App',
      home: RegisterScreen(), // Muestra la pantalla de inicio de sesión
    );
  }
}


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState(); // Estado del formulario
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Clave para validar formulario

  // Controladores para campos del formulario
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  void showMessage(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }


  void register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.20.30:5000/api/login'), // URL API .NET
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'password': passController.text.trim(), // Envia contraseña
          'correo': correoController.text.trim().toLowerCase(), // Envia correo
        }),
      );

      // Si el login fue exitoso
      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage("✅ Usuario ingresó correctamente");
        Navigator.pop(context); // Vuelve atrás (puedes reemplazar por navegar a HomeScreen)
      } else {
        showMessage("❌ Error: Credenciales inválidas");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo correo
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

                // Campo contraseña
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

                // Botón para iniciar sesión
                ElevatedButton(
                  onPressed: register,
                  child: Text('Iniciar Sesión'),
                ),

                // Botón para ver lista de usuarios
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListaUsuariosScreen(), // Ir a lista
                      ),
                    );
                  },
                  child: Text('Ver usuarios registrados'),
                ),

                SizedBox(height: 20),

                // Opción para registrarse
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿No tienes cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(), // Ir a pantalla de registro
                          ),
                        );
                      },
                      child: Text('Regístrate'),
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

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla de Registro')),
      body: Center(
        child: Text('Aquí iría la pantalla para registrar usuarios.'),
      ),
    );
  }
}

