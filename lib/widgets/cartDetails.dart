import 'package:flutter/material.dart';

import '../core/router/items/model_cart.dart';

class CartDetails extends StatelessWidget {
  final Cart cart;

  const CartDetails({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del Pedido #${cart.id}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fecha de Compra: ${cart.fechaCompra.toLocal()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "Total: \$${cart.total.toStringAsFixed(4)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 32),
            Text(
              "Productos:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text("Cantidad: ${item.quantity}"),
                      trailing: Text("\$${item.price * item.quantity}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}