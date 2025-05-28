class Cliente {
  final int? id; // puede ser nulo, no requerido
  final String nombre;
  final String correo;
  final String identificacion;
  final String direccion;
  final String telefono;

  Cliente({
    this.id, // ❌ sin required
    required this.nombre,
    required this.correo,
    required this.identificacion,
    required this.direccion,
    required this.telefono,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      identificacion: json['identificacion'],
      direccion: json['direccion'],
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'identificacion': identificacion,
      'direccion': direccion,
      'telefono': telefono,
    };
  }
}
