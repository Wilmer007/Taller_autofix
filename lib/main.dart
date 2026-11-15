import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'models/usuario.dart';
import 'screens/home_cliente.dart';
import 'screens/home_empleado.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller AutoFix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

// Decide qué pantalla mostrar según si hay sesión y cuál es el rol
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    const cargando = Scaffold(body: Center(child: CircularProgressIndicator()));

    return StreamBuilder<User?>(
      stream: auth.estadoAuth,
      builder: (context, snapAuth) {
        if (snapAuth.connectionState == ConnectionState.waiting) {
          return cargando;
        }
        final user = snapAuth.data;
        if (user == null) return const LoginScreen();

        return FutureBuilder<Usuario>(
          future: auth.obtenerUsuario(user.uid),
          builder: (context, snapUsuario) {
            if (snapUsuario.hasError) {
              return const Scaffold(
                  body: Center(child: Text('Error al cargar el perfil')));
            }
            if (!snapUsuario.hasData) return cargando;
            final usuario = snapUsuario.data!;
            return usuario.rol == 'empleado'
                ? HomeEmpleado(usuario: usuario)
                : HomeCliente(usuario: usuario);
          },
        );
      },
    );
  }
}