import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';
import '../widgets/campo_texto.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente; // null = crear, con valor = editar
  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ClienteService();
  late final _nombre = TextEditingController(text: widget.cliente?.nombre);
  late final _telefono = TextEditingController(text: widget.cliente?.telefono);
  late final _correo = TextEditingController(text: widget.cliente?.correo);
  late final _direccion =
      TextEditingController(text: widget.cliente?.direccion);
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _correo.dispose();
    _direccion.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final c = Cliente(
      id: widget.cliente?.id ?? '',
      nombre: _nombre.text.trim(),
      telefono: _telefono.text.trim(),
      correo: _correo.text.trim(),
      direccion: _direccion.text.trim(),
    );
    try {
      if (widget.cliente == null) {
        await _service.crear(c);
      } else {
        await _service.actualizar(c);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar. Inténtalo de nuevo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.cliente != null;
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar cliente' : 'Nuevo cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CampoTexto(
                controller: _nombre,
                etiqueta: 'Nombre completo',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
              ),
              CampoTexto(
                controller: _telefono,
                etiqueta: 'Teléfono',
                tipo: TextInputType.phone,
                validator: (v) => (v == null || v.trim().length < 8)
                    ? 'Ingresa un teléfono válido'
                    : null,
              ),
              CampoTexto(
                controller: _correo,
                etiqueta: 'Correo (opcional)',
                tipo: TextInputType.emailAddress,
                validator: (v) =>
                    (v != null && v.isNotEmpty && !v.contains('@'))
                        ? 'Correo no válido'
                        : null,
              ),
              CampoTexto(controller: _direccion, etiqueta: 'Dirección (opcional)'),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _guardando ? null : _guardar,
                  child: _guardando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(editando ? 'Guardar cambios' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}