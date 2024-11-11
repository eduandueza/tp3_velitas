import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/cartItem_provider.dart';
import 'package:flutter_application_1/presentations/providers/cartPendiente_provider.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_application_1/widgets/quantity_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/items/model_cart.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CarritoScreen extends ConsumerWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(cartPendienteProvider);
    final cartItems = provider?.items ?? []; // nos aseguramos que no sea null cartItems, a pesar de que NUNCA puede ser null, flutter chilla. odio flutter
    double total = cartItems.fold(0, (sum, item) {
      return sum + (item.price * item.quantity);
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: const Text('Carrito'),
      ),
      body: Column(
        children: [
          const LogoWidget(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Precio: \$${item.price.toStringAsFixed(2)}'),
                  trailing: QuantityWidget(
                    cantidad: item.quantity,
                    aumentarCantidad: () {
                      ref.read(cartPendienteProvider.notifier).increaseQuantity(item.name);
                    },
                    disminuirCantidad: () {
                      ref.read(cartPendienteProvider.notifier).decreaseQuantity(item.name);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Verifica si el carrito está vacío
              if (cartItems.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Carrito vacío'),
                      content: const Text('No compraste nada che.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirmación de compra'),
                      content: const Text('¿Estás seguro de que deseas realizar esta compra?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); 
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Agregando carrito a los pedidos pendientes
                            final newCart = Cart(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              fechaCompra: DateTime.now(),
                              items: List.from(cartItems),
                              total: total,
                            );

                            // Agregar al carrito pendiente
                            //ref.read(cartPendienteProvider.notifier).addCart(newCart);

                            // Vaciar carrito pendiente
                            ref.read(cartPendienteProvider.notifier).clearCartPendiente();

                            // Redirigir a pantalla de compra aprobada
                            Navigator.of(context).pop();
                            context.go('/aprobada');
                          },
                          child: const Text('Sí'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Comprar'),
          ),
        ],
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }
}
