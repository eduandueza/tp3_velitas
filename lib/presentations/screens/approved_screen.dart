import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';

class ApprovedScreen extends StatelessWidget {
  const ApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compra Aprobada'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const LogoWidget(), // Aquí puedes usar tu logo si lo deseas
          const SizedBox(height: 20),
          Icon(
            Icons.check_circle, // Icono de verificación
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(height: 20),
          const Text(
            '¡Gracias por tu compra!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Tu pedido ha sido procesado con éxito.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }
}
