import 'package:flutter/material.dart';

import '../../core/router/items/model_cart.dart';

class ShippingDetailsScreen extends StatelessWidget {
  final Cart cart;

  const ShippingDetailsScreen({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos de Envio"),
      ),
      body: Center(
        child: const Text("Aca van los datitos del enevio"), 
      ),
    );
  }
}