import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/vehiculo.dart';
import '../services/cliente_service.dart';
import '../services/vehiculo_service.dart';
import 'cliente_form_screen.dart';
import 'vehiculo_form_screen.dart';

class ClienteDetalleScreen extends StatelessWidget {
  final String clienteId;
  const ClienteDetalleScreen({super.key, required this.clienteId});

  Future<bool> _confirmar(BuildContext context, String titulo, String texto) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: Text(texto),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    return ok == true;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Cliente?>(
      stream: ClienteService().porId(clienteId),
      builder: (context, snapCliente) {
        final cliente = snapCliente.data;
        if (cliente == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(cliente.nombre),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ClienteFormScreen(cliente: cliente)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final ok = await _confirmar(
                    context,
                    'Eliminar cliente',
                    'Se eliminará a ${cliente.nombre} y todos sus vehículos. ¿Continuar?',
                  );
                  if (ok) {
                    await ClienteService().eliminar(cliente.id);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VehiculoFormScreen(clienteId: cliente.id)),
            ),
            icon: const Icon(Icons.directions_car),
            label: const Text('Vehículo'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(cliente.telefono),
              ),
              if (cliente.correo.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(cliente.correo),
                ),
              if (cliente.direccion.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(cliente.direccion),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Vehículos',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Expanded(
                child: StreamBuilder<List<Vehiculo>>(
                  stream: VehiculoService().porCliente(cliente.id),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return const Center(
                          child: Text('Error al cargar vehículos'));
                    }
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final lista = snap.data!;
                    if (lista.isEmpty) {
                      return const Center(
                          child: Text('Este cliente no tiene vehículos'));
                    }
                    return ListView.builder(
                      itemCount: lista.length,
                      itemBuilder: (context, i) {
                        final v = lista[i];
                        return ListTile(
                          leading: const Icon(Icons.directions_car),
                          title: Text('${v.marca} ${v.modelo} ${v.anio}'),
                          subtitle:
                              Text('Placa ${v.placa} · ${v.kilometraje} km'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VehiculoFormScreen(
                                  clienteId: cliente.id, vehiculo: v),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final ok = await _confirmar(
                                context,
                                'Eliminar vehículo',
                                '¿Eliminar el vehículo con placa ${v.placa}?',
                              );
                              if (ok) await VehiculoService().eliminar(v.id);
                            },
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
      },
    );
  }
}