import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

class HomeCliente extends StatelessWidget {
  final Usuario usuario;
  const HomeCliente({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().cerrarSesion(),
          ),
        ],
      ),
      body: Center(child: Text('Bienvenido, ${usuario.nombre} (cliente)')),
    );
  }
}