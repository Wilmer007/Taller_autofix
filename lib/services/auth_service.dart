import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get estadoAuth => _auth.authStateChanges();

  Future<void> registrar({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: correo,
      password: password,
    );
    await _db.collection('usuarios').doc(cred.user!.uid).set({
      'nombre': nombre,
      'correo': correo,
      'rol': 'cliente', // siempre cliente al registrarse
      'creadoEn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> iniciarSesion(String correo, String password) async {
    await _auth.signInWithEmailAndPassword(email: correo, password: password);
  }

  Future<void> cerrarSesion() => _auth.signOut();

  Future<Usuario> obtenerUsuario(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) {
      // Si el perfil aún no se guarda, se asume el rol con menos permisos
      return Usuario(uid: uid, nombre: '', correo: '', rol: 'cliente');
    }
    return Usuario.fromMap(uid, doc.data()!);
  }
}

String mensajeErrorAuth(String code) {
  switch (code) {
    case 'invalid-credential':
    case 'user-not-found':
    case 'wrong-password':
      return 'Correo o contraseña incorrectos';
    case 'email-already-in-use':
      return 'Ese correo ya está registrado';
    case 'weak-password':
      return 'La contraseña es muy débil (mínimo 6 caracteres)';
    case 'invalid-email':
      return 'El correo no es válido';
    default:
      return 'Ocurrió un error. Inténtalo de nuevo';
  }
}