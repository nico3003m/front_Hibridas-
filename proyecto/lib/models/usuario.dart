class Usuario {
  final int? id;
  final String nombre;
  final String correo;
  final String? password;
  final String? identificacion;

  Usuario({
    this.id,
    required this.nombre,
    required this.correo,
    required this.password,
    required this.identificacion,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'password': password,
      'identificacion': identificacion,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      password: json['password'],
      identificacion: json['identificacion'],
    );
  }
}
