import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/carrito_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarritoItemScreen extends ConsumerWidget {
  const CarritoItemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(carritoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('El carrito se encuentra vacío'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Precio: \$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      ref.read(carritoProvider.notifier).removeItem(item.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.name} eliminado del carrito')),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Total: \$${ref.watch(carritoProvider.notifier).total.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}