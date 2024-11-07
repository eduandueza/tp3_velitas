import 'package:flutter/material.dart';

class ShippingInformationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShippingInformationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), 
          textStyle: const TextStyle(fontSize: 18), 
        ),
        child: const Text("Datos de Envio"),
      ),
    );
  }
}