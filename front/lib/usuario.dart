class Usuario {
  final int id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String correo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.correo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correo: json['correo'],
    );
  }
}
