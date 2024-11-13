


import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_order.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/OrderStateEnum.dart';
import 'package:flutter_application_1/presentations/providers/order_provider.dart';
import 'package:flutter_application_1/widgets/adminCartDetails.dart';
import 'package:flutter_application_1/widgets/cartDetails.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/router/items/model_order.dart';

class AdminOrderCard extends ConsumerWidget {
  final UserOrder order;

  const AdminOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersNotifier = ref.read(orderProvider.notifier);  

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
              "Pedido #${order.id}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Fecha de Compra: ${order.cart.fechaCompra.toLocal()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Total: \$${order.cart.total.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
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
                onPressed: () => _showModifyStateDialog(context, ordersNotifier),
                child: const Text("Modificar Estado"),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => adminCartDetails(cart: order.cart),
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

  
  void _showModifyStateDialog(BuildContext context, OrderNotifier ordersNotifier) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modificar Estado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              DropdownButton<OrderState>(
                value: order.estado,
                items: OrderState.values.map((OrderState state) {
                  return DropdownMenuItem<OrderState>(
                    value: state,
                    child: Text(state.name),
                  );
                }).toList(),
                onChanged: (newState) {
                  if (newState != null && newState != order.estado) {
                    ordersNotifier.updateOrderStatus(order.id, newState);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Estado cambiado a ${newState.name}")),
                    );
                    Navigator.of(context).pop(); 
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
