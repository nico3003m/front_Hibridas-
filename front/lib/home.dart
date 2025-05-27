// Importa los paquetes necesarios para crear la interfaz y hacer peticiones HTTP
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'usuario.dart'; // Importa el modelo Usuario (debe estar definido en otro archivo)

// Pantalla que mostrará la lista completa de usuarios
class ListaUsuariosScreen extends StatefulWidget {
  const ListaUsuariosScreen({Key? key}) : super(key: key);

  @override
  State<ListaUsuariosScreen> createState() => _ListaUsuariosScreenState();
}

// Estado de la pantalla que se encarga de cargar y mostrar los usuarios
class _ListaUsuariosScreenState extends State<ListaUsuariosScreen> {
  // Variable que guardará la lista de usuarios cargados desde la API
  late Future<List<Usuario>> _usuarios;

  // initState se ejecuta cuando se abre la pantalla por primera vez
  @override
  void initState() {
    super.initState();
    // Cargar los usuarios al iniciar la pantalla
    _usuarios = obtenerUsuarios();
  }

  // Función que realiza la petición HTTP GET a la API para obtener los usuarios
  Future<List<Usuario>> obtenerUsuarios() async {
    final response = await http.get(
      Uri.parse('http://192.168.20.30:5000/api/usuarios'), // URL del backend .NET
    );

    // Si la respuesta fue exitosa (código 200)
    if (response.statusCode == 200) {
      final List<dynamic> listaJson = json.decode(response.body); // Convierte el JSON
      // Transforma cada JSON en un objeto Usuario y devuelve la lista
      return listaJson.map((json) => Usuario.fromJson(json)).toList();
    } else {
      // Si hubo error, lanza una excepción
      throw Exception('Error al cargar usuarios');
    }
  }

  // Método que construye la interfaz de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de clientes')), // Título de la app
      body: FutureBuilder<List<Usuario>>( // Widget que espera los datos futuros (_usuarios)
        future: _usuarios,
        builder: (context, snapshot) {
          // Mientras se espera la respuesta, muestra un círculo de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          // Si hubo un error al cargar los datos
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          // Si no hay usuarios en la base de datos
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay usuarios registrados'));
          }

          // Si todo está bien, muestra la lista de usuarios
          final usuarios = snapshot.data!;

          return ListView.builder(
            itemCount: usuarios.length, // Número de usuarios
            itemBuilder: (context, index) {
              final u = usuarios[index]; // Usuario actual

              // Muestra los datos del usuario en una tarjeta
              return Card(
                child: ListTile(
                  title: Text(u.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dirección: ${u.direccion}"),
                      Text("Teléfono: ${u.telefono}"),
                      Text("Correo: ${u.correo}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
