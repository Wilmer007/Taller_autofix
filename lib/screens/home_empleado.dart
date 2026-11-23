import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import 'clientes_screen.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Bienvenido, ${usuario.nombre}',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes y vehículos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClientesScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}