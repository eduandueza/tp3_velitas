import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/cartItem_provider.dart';
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
    final cartItems = ref.watch(carritoProvider);
    //final cartProvider= ref.watch(carritosProvider);

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
                      ref.read(carritoProvider.notifier).increaseQuantity(item.name);
                    },
                    disminuirCantidad: () {
                      ref.read(carritoProvider.notifier).decreaseQuantity(item.name);
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
              // verifica si el carrito está vacío
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
                             //agregando carrito
                            final newCart = Cart(
                              id: DateTime.now().millisecondsSinceEpoch.toString(), 
                              fechaCompra: DateTime.now(),
                              items: List.from(cartItems), 
                              total: total,
                            );
                            
                           
                            
                             ref.read(orderProvider.notifier).addOrder(newCart);

                            ref.read(carritosProvider.notifier).addCart(newCart);
                            ref.read(carritoProvider.notifier).resetearCartItemProvider();

                           // ref.read(carritoProvider.notifier).clearCart(); 
                            
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
