import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';

class RegisterUsuarioScreen extends StatefulWidget {
  @override
  _RegisterUsuarioScreenState createState() => _RegisterUsuarioScreenState();
}

class _RegisterUsuarioScreenState extends State<RegisterUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identificacionController =
      TextEditingController();

  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    Usuario nuevoUsuario = Usuario(
      nombre: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      password: _passwordController.text.trim(),
      identificacion: _identificacionController.text.trim(),
    );

    final resultado = await ApiService.registerUsuario(nuevoUsuario.toJson());

    setState(() {
      _loading = false;
    });

    if (resultado) {
      setState(() {
        _successMessage = 'Usuario registrado correctamente';
        _nombreController.clear();
        _correoController.clear();
        _passwordController.clear();
        _identificacionController.clear();
      });
    } else {
      setState(() {
        _errorMessage = 'Error al registrar usuario. Puede que ya exista.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_errorMessage != null)
                    Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                  if (_successMessage != null)
                    Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green),
                    ),

                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator:
                        (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: _correoController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                    ),
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

                  SizedBox(height: 10),

                  TextFormField(
                    controller: _identificacionController,
                    decoration: InputDecoration(labelText: 'Identificación'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Ingrese su identificación' : null,
                  ),
                  SizedBox(height: 20),

                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _registrarUsuario,
                        child: Text('Registrarse'),
                      ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('¿Ya tienes cuenta? Iniciar sesión'),
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
