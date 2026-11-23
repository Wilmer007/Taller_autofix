import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String etiqueta;
  final TextInputType tipo;
  final String? Function(String?)? validator;

  const CampoTexto({
    super.key,
    required this.controller,
    required this.etiqueta,
    this.tipo = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }
}