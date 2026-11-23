import 'package:cloud_firestore/cloud_firestore.dart';

class Cliente {
  final String id;
  final String nombre;
  final String telefono;
  final String correo;
  final String direccion;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.correo = '',
    this.direccion = '',
  });

  factory Cliente.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Cliente(
      id: doc.id,
      nombre: d['nombre'] ?? '',
      telefono: d['telefono'] ?? '',
      correo: d['correo'] ?? '',
      direccion: d['direccion'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'telefono': telefono,
        'correo': correo,
        'direccion': direccion,
      };
}