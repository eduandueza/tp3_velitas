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
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LogoWidget(), // Aquí puedes usar tu logo si lo deseas
          SizedBox(height: 20),
          Icon(
            Icons.check_circle, // Icono de verificación
            color: Colors.green,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            '¡Gracias por tu compra!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
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
