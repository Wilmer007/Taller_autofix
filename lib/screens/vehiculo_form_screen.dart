import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../services/vehiculo_service.dart';
import '../widgets/campo_texto.dart';

class VehiculoFormScreen extends StatefulWidget {
  final String clienteId;
  final Vehiculo? vehiculo; // null = crear
  const VehiculoFormScreen({super.key, required this.clienteId, this.vehiculo});

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = VehiculoService();
  late final _marca = TextEditingController(text: widget.vehiculo?.marca);
  late final _modelo = TextEditingController(text: widget.vehiculo?.modelo);
  late final _anio =
      TextEditingController(text: widget.vehiculo?.anio.toString());
  late final _placa = TextEditingController(text: widget.vehiculo?.placa);
  late final _color = TextEditingController(text: widget.vehiculo?.color);
  late final _km =
      TextEditingController(text: widget.vehiculo?.kilometraje.toString());
  bool _guardando = false;

  @override
  void dispose() {
    _marca.dispose();
    _modelo.dispose();
    _anio.dispose();
    _placa.dispose();
    _color.dispose();
    _km.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final v = Vehiculo(
      id: widget.vehiculo?.id ?? '',
      clienteId: widget.clienteId,
      marca: _marca.text.trim(),
      modelo: _modelo.text.trim(),
      anio: int.parse(_anio.text.trim()),
      placa: _placa.text.trim().toUpperCase(),
      color: _color.text.trim(),
      kilometraje: int.tryParse(_km.text.trim()) ?? 0,
    );
    try {
      if (widget.vehiculo == null) {
        await _service.crear(v);
      } else {
        await _service.actualizar(v);
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

  String? _obligatorio(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  @override
  Widget build(BuildContext context) {
    final editando = widget.vehiculo != null;
    final anioMax = DateTime.now().year + 1;
    return Scaffold(
      appBar:
          AppBar(title: Text(editando ? 'Editar vehículo' : 'Nuevo vehículo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CampoTexto(
                  controller: _marca, etiqueta: 'Marca', validator: _obligatorio),
              CampoTexto(
                  controller: _modelo,
                  etiqueta: 'Modelo',
                  validator: _obligatorio),
              CampoTexto(
                controller: _anio,
                etiqueta: 'Año',
                tipo: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null || n < 1950 || n > anioMax) {
                    return 'Ingresa un año entre 1950 y $anioMax';
                  }
                  return null;
                },
              ),
              CampoTexto(
                  controller: _placa, etiqueta: 'Placa', validator: _obligatorio),
              CampoTexto(controller: _color, etiqueta: 'Color (opcional)'),
              CampoTexto(
                controller: _km,
                etiqueta: 'Kilometraje (opcional)',
                tipo: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = int.tryParse(v.trim());
                  return (n == null || n < 0) ? 'Número no válido' : null;
                },
              ),
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