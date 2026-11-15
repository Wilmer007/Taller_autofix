class Usuario {
  final String uid;
  final String nombre;
  final String correo;
  final String rol; // 'empleado' o 'cliente'

  Usuario({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.rol,
  });

  factory Usuario.fromMap(String uid, Map<String, dynamic> data) {
    return Usuario(
      uid: uid,
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      rol: data['rol'] ?? 'cliente',
    );
  }
}