import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehiculo.dart';

class VehiculoService {
  final _col = FirebaseFirestore.instance.collection('vehiculos');

  Stream<List<Vehiculo>> porCliente(String clienteId) => _col
      .where('clienteId', isEqualTo: clienteId)
      .snapshots()
      .map((snap) =>
          snap.docs.map(Vehiculo.fromDoc).toList()
            ..sort((a, b) => a.placa.compareTo(b.placa)));

  Future<void> crear(Vehiculo v) =>
      _col.add({...v.toMap(), 'creadoEn': FieldValue.serverTimestamp()});

  Future<void> actualizar(Vehiculo v) => _col.doc(v.id).update(v.toMap());

  Future<void> eliminar(String id) => _col.doc(id).delete();
}