import 'package:flutter/material.dart';

import '../../core/router/items/model_cart.dart';

class ShippingDetailsScreen extends StatelessWidget {
  final Cart cart;

  const ShippingDetailsScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos de Envio"),
      ),
      body: const Center(
        child: Text("Aca van los datitos del enevio"), 
      ),
    );
  }
}