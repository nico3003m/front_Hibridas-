import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/cliente.dart';
import '../globals.dart';

const String baseUrl =
    "http://192.168.20.56:5220/api"; // Cambia PORT por el tuyo

class ApiService {
  static Future<Usuario?> login(String correo, String password) async {
    try {
      print('Intentando login en $baseUrl/auth/login');
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, 'password': password}),
          )
          .timeout(const Duration(seconds: 10)); // timeout opcional

      print('Código respuesta: ${response.statusCode}');
      print('Cuerpo respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final cookie = response.headers['set-cookie'];
        if (cookie != null) {
          sessionCookie = cookie.split(';').first;
        }

        final data = jsonDecode(response.body);
        userId = data['id'];
        return Usuario.fromJson(data);
      } else {
        print('Error login: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  static Future<bool> registerUsuario(Map<String, dynamic> usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario),
    );

    // Aceptar códigos 200 o 201 como éxito
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<List<Cliente>> getClientes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cliente/list/'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie ?? '',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Cliente.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener clientes');
    }
  }

  static Future<bool> crearCliente(Map<String, dynamic> data) async {
    print("Intentando crear cliente...");
    print("Datos enviados: ${jsonEncode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cliente'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print("Respuesta: ${response.statusCode} - ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error al hacer POST: $e");
      return false;
    }
  }

  static Future<bool> actualizarCliente(
    int id,
    Map<String, dynamic> cliente,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cliente/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie ?? '',
      },
      body: jsonEncode(cliente),
    );

    return response.statusCode == 204;
  }

  static Future<bool> eliminarCliente(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cliente/$id'),
      headers: {'Cookie': sessionCookie ?? ''},
    );

    return response.statusCode == 204;
  }
}
