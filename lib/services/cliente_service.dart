import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cliente.dart';

class ClienteService {
  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('clientes');

  // Se ordena en Dart para no necesitar índices extra en Firestore
  Stream<List<Cliente>> clientes() => _col.snapshots().map((snap) {
        final lista = snap.docs.map(Cliente.fromDoc).toList();
        lista.sort((a, b) =>
            a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
        return lista;
      });

  Stream<Cliente?> porId(String id) => _col
      .doc(id)
      .snapshots()
      .map((doc) => doc.exists ? Cliente.fromDoc(doc) : null);

  Future<void> crear(Cliente c) =>
      _col.add({...c.toMap(), 'creadoEn': FieldValue.serverTimestamp()});

  Future<void> actualizar(Cliente c) => _col.doc(c.id).update(c.toMap());

  // Al eliminar un cliente también se eliminan sus vehículos
  Future<void> eliminar(String id) async {
    final batch = _db.batch();
    final vehiculos =
        await _db.collection('vehiculos').where('clienteId', isEqualTo: id).get();
    for (final v in vehiculos.docs) {
      batch.delete(v.reference);
    }
    batch.delete(_col.doc(id));
    await batch.commit();
  }
}