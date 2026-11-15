import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

class HomeEmpleado extends StatelessWidget {
  final Usuario usuario;
  const HomeEmpleado({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del taller'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().cerrarSesion(),
          ),
        ],
      ),
      body: Center(child: Text('Bienvenido, ${usuario.nombre} (empleado)')),
    );
  }
}