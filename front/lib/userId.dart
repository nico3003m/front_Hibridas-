import 'package:shared_preferences/shared_preferences.dart';

class UsuarioSesion {
  static final UsuarioSesion _instancia = UsuarioSesion._interna();

  factory UsuarioSesion() {
    return _instancia;
  }

  UsuarioSesion._interna();

  int? id;

  Future<void> guardar(int nuevoId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', nuevoId);
    id = nuevoId;
  }

  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('user_id');
  }

  Future<void> limpiar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    id = null;
  }
}