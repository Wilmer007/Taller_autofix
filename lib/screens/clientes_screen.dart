import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';
import 'cliente_detalle_screen.dart';
import 'cliente_form_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final _service = ClienteService();
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClienteFormScreen()),
        ),
        icon: const Icon(Icons.person_add),
        label: const Text('Cliente'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por nombre o teléfono',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _busqueda = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Cliente>>(
              stream: _service.clientes(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return const Center(child: Text('Error al cargar clientes'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lista = snap.data!
                    .where((c) =>
                        c.nombre.toLowerCase().contains(_busqueda) ||
                        c.telefono.contains(_busqueda))
                    .toList();
                if (lista.isEmpty) {
                  return const Center(child: Text('No hay clientes'));
                }
                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, i) {
                    final c = lista[i];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(c.nombre),
                      subtitle: Text(c.telefono),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClienteDetalleScreen(clienteId: c.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}