import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'usuario.dart'; // Modelo de Usuario

class ListaUsuariosScreen extends StatefulWidget {
  const ListaUsuariosScreen({Key? key}) : super(key: key);

  @override
  State<ListaUsuariosScreen> createState() => _ListaUsuariosScreenState();
}

class _ListaUsuariosScreenState extends State<ListaUsuariosScreen> {
  late Future<List<Usuario>> _usuarios;

  @override
  void initState() {
    super.initState();
    _usuarios = obtenerUsuarios();
  }

  Future<List<Usuario>> obtenerUsuarios() async {
    final response = await http.get(
      Uri.parse('http://localhost:5220/api/cliente'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = json.decode(response.body);
      return listaJson.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  Future<void> eliminarUsuario(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5220/api/cliente/$id'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Usuario eliminado")));
      setState(() {
        _usuarios = obtenerUsuarios(); // Recargar lista
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error al eliminar usuario")));
    }
  }

  void mostrarDialogoEditar(Usuario usuario) {
    final nombreCtrl = TextEditingController(text: usuario.nombre);
    final correoCtrl = TextEditingController(text: usuario.correo);
    final direccionCtrl = TextEditingController(text: usuario.direccion);
    final telefonoCtrl = TextEditingController(text: usuario.telefono);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Editar usuario"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nombreCtrl,
                    decoration: InputDecoration(labelText: "Nombre"),
                  ),
                  TextField(
                    controller: correoCtrl,
                    decoration: InputDecoration(labelText: "Correo"),
                  ),
                  TextField(
                    controller: direccionCtrl,
                    decoration: InputDecoration(labelText: "Dirección"),
                  ),
                  TextField(
                    controller: telefonoCtrl,
                    decoration: InputDecoration(labelText: "Teléfono"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final response = await http.put(
                    Uri.parse(
                      'http://localhost:5220/api/cliente/${usuario.id}',
                    ),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'id': usuario.id,
                      'nombre': nombreCtrl.text,
                      'correo': correoCtrl.text,
                      'direccion': direccionCtrl.text,
                      'telefono': telefonoCtrl.text,
                    }),
                  );

                  Navigator.pop(context);

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("✅ Usuario actualizado")),
                    );
                    setState(() {
                      _usuarios = obtenerUsuarios();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Error al actualizar")),
                    );
                  }
                },
                child: Text("Guardar"),
              ),
            ],
          ),
    );
  }

  void mostrarDetalles(Usuario usuario) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Detalles del usuario"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nombre: ${usuario.nombre}"),
                Text("Correo: ${usuario.correo}"),
                Text("Dirección: ${usuario.direccion}"),
                Text("Teléfono: ${usuario.telefono}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cerrar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de clientes')),
      body: FutureBuilder<List<Usuario>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No hay usuarios registrados'));

          final usuarios = snapshot.data!;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final u = usuarios[index];

              return Card(
                child: ListTile(
                  title: Text(u.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Correo: ${u.correo}"),
                      Text("Teléfono: ${u.telefono}"),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'ver')
                        mostrarDetalles(u);
                      else if (value == 'editar')
                        mostrarDialogoEditar(u);
                      else if (value == 'eliminar')
                        eliminarUsuario(u.id);
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(value: 'ver', child: Text('Ver')),
                          PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(
                            value: 'eliminar',
                            child: Text('Eliminar'),
                          ),
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
