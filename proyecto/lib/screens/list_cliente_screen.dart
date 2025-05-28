import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListClienteScreen extends StatefulWidget {
  const ListClienteScreen({Key? key}) : super(key: key);

  @override
  _ListClienteScreenState createState() => _ListClienteScreenState();
}

class _ListClienteScreenState extends State<ListClienteScreen> {
  List<Cliente> _clientes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // o prefs.remove('usuario') si guardas con clave específica

    // Redirigir al login y evitar regresar a esta pantalla
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> _cargarClientes() async {
    setState(() => _loading = true);
    final clientes = await ApiService.getClientes();
    setState(() {
      _clientes = clientes;
      _loading = false;
    });
  }

  Future<void> _eliminarCliente(int id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('¿Eliminar cliente?'),
            content: Text('Esta acción no se puede deshacer.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirmado == true) {
      final exito = await ApiService.eliminarCliente(id);
      if (exito) _cargarClientes();
    }
  }

  void _mostrarFormulario([Cliente? clienteExistente]) async {
    print("Si funciona el boton");
    final resultado = await showDialog<Cliente>(
      context: context,
      builder: (_) => _FormularioCliente(cliente: clienteExistente),
    );

    if (resultado != null) {
      if (clienteExistente == null) {
        await ApiService.crearCliente(
          resultado.toJson(),
        ); // ✅ AQUÍ SE HACE EL POST
      } else {
        await ApiService.actualizarCliente(resultado.id!, resultado.toJson());
      }
      _cargarClientes(); // ✅ Se refresca la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Text('Cerrar sesión'),
                      content: Text('¿Estás seguro que quieres cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Cerrar sesión'),
                        ),
                      ],
                    ),
              );

              if (confirmar == true) {
                await _cerrarSesion();
              }
            },
          ),
        ],
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _clientes.length,
                itemBuilder: (_, index) {
                  final cliente = _clientes[index];
                  return ListTile(
                    title: Text(cliente.nombre),
                    subtitle: Text(cliente.correo),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _mostrarFormulario(cliente),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarCliente(cliente.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class _FormularioCliente extends StatefulWidget {
  final Cliente? cliente;
  _FormularioCliente({this.cliente});

  @override
  State<_FormularioCliente> createState() => _FormularioClienteState();
}

class _FormularioClienteState extends State<_FormularioCliente> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombre;
  late TextEditingController _correo;
  late TextEditingController _identificacion;
  late TextEditingController _direccion;
  late TextEditingController _telefono;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.cliente?.nombre ?? '');
    _correo = TextEditingController(text: widget.cliente?.correo ?? '');
    _identificacion = TextEditingController(
      text: widget.cliente?.identificacion ?? '',
    );
    _direccion = TextEditingController(text: widget.cliente?.direccion ?? '');
    _telefono = TextEditingController(text: widget.cliente?.telefono ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.cliente == null ? 'Crear Cliente' : 'Editar Cliente'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _correo,
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _identificacion,
                decoration: InputDecoration(labelText: 'Identificación'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _direccion,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _telefono,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final cliente = Cliente(
                id: widget.cliente?.id,
                nombre: _nombre.text,
                correo: _correo.text,
                identificacion: _identificacion.text,
                direccion: _direccion.text,
                telefono: _telefono.text,
              );
              Navigator.pop(context, cliente);
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
