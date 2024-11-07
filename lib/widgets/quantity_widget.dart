import 'package:flutter/material.dart';

class QuantityWidget extends StatelessWidget {
  final int cantidad;
  final VoidCallback aumentarCantidad;
  final VoidCallback disminuirCantidad;

  const QuantityWidget({
    super.key,
    required this.cantidad,
    required this.aumentarCantidad,
    required this.disminuirCantidad,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 24),
          onPressed: disminuirCantidad,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cantidad.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 24),
          onPressed: aumentarCantidad,
        ),
      ],
    );
  }
}
