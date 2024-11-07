import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/shippingInformationButton.dart';

import '../core/router/items/model_cart.dart';
import '../presentations/screens/ShippingDetailsScreen.dart';

class CartDetails extends StatelessWidget {
  final Cart cart;

  const CartDetails({super.key, required this.cart});

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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "Total: \$${cart.total.toStringAsFixed(4)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 32),
            const Text(
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
            ),const SizedBox(height: 16), 
              ShippingInformationButton(
               onPressed: () {
               
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShippingDetailsScreen(cart: cart), 
                  ),
                );
              },
            ), 
          ],
        ),
      ),
    );
  }
}