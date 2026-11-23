import 'package:cloud_firestore/cloud_firestore.dart';

class Vehiculo {
  final String id;
  final String clienteId;
  final String marca;
  final String modelo;
  final int anio;
  final String placa;
  final String color;
  final int kilometraje;

  Vehiculo({
    required this.id,
    required this.clienteId,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.placa,
    this.color = '',
    this.kilometraje = 0,
  });

  factory Vehiculo.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Vehiculo(
      id: doc.id,
      clienteId: d['clienteId'] ?? '',
      marca: d['marca'] ?? '',
      modelo: d['modelo'] ?? '',
      anio: (d['anio'] ?? 0).toInt(),
      placa: d['placa'] ?? '',
      color: d['color'] ?? '',
      kilometraje: (d['kilometraje'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'clienteId': clienteId,
        'marca': marca,
        'modelo': modelo,
        'anio': anio,
        'placa': placa,
        'color': color,
        'kilometraje': kilometraje,
      };
}