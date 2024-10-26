import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: Column(
        children: [
          LogoWidget(),
          const SizedBox(height: 20),
          Center(child: const Text('Contenido del Carrito')),
        ],
      ),
      bottomNavigationBar: MainMenu(),
    );
  }
}
