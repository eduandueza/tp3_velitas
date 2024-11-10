import 'package:flutter/material.dart';
import 'package:flutter_application_1/OrderStateEnum.dart';
import 'package:flutter_application_1/widgets/cartDetails.dart';

import '../core/router/items/model_order.dart';

class OrderCard  extends StatelessWidget {
  final UserOrder order ;

  const OrderCard ({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    final cart = order.cart;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pedido #${cart.id}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Fecha de Compra: ${cart.fechaCompra.toLocal()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Total: \$${cart.total.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ), const SizedBox(height: 8),
            Text(
              "Estado: ${order.estado.name}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                 color: order.color,
                 fontWeight: FontWeight.bold,
               ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartDetails(cart: cart),
                    ),
                  );
                },
                child: const Text("Ver detalles"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}