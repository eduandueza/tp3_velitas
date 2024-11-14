import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_cartPendiente.dart';
import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_application_1/domain/candle.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_application_1/presentations/providers/cartItem_provider.dart';
import 'package:flutter_application_1/presentations/providers/cartPendiente_provider.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_application_1/widgets/quantity_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/router/items/model_cart.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CarritoScreen extends ConsumerWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final cartPendiente = ref.watch(cartPendienteProvider);
    final userData = ref.watch(userProvider);
    
    if (cartPendiente == null) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButtonWidget(),
          title: const Text('Carrito'),
        ),
        body: const Center(child: CircularProgressIndicator()), 
      );
    }

    if (cartPendiente.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Carrito'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 50, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'No has comprado nada 😢', 
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black, 
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const MainMenu(),
      );
    }

    double total = cartPendiente.items.fold(0, (sum, item) {
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
              itemCount: cartPendiente.items.length,
              itemBuilder: (context, index) {
                final item = cartPendiente.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Precio: \$${item.price.toStringAsFixed(2)}'),
                  trailing: QuantityWidget(
                    cantidad: item.quantity,
                    aumentarCantidad: () {
                      ref.read(cartPendienteProvider.notifier).increaseQuantity(item.id);
                    },
                    disminuirCantidad: () {
                       
                       if (item.quantity == 1) {
                        _showRemoveItemDialog(context, ref, item.id);
                      } else {
                        
                          ref.read(cartPendienteProvider.notifier).decreaseQuantity(item.id);
                      }
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
            onPressed: () async {
              bool stockSuficiente = true;
              String mensajeError = '';

              for (var item in cartPendiente.items) {

               Candle ?candle=null;

               try {
               candle = ref.read(candleProvider).firstWhere(
                  (candle) => candle.name == item.name
                );
               }catch (e){
                
               }
              
                if (candle != null && item.quantity > candle.stock) {
                  stockSuficiente = false;
                  mensajeError = 'No hay suficiente stock para ${item.name}. Solo quedan ${candle.stock} unidades.';
                  break;
                }
              }

              if (!stockSuficiente) {
                // Si el stock no es suficiente, mostrar un mensaje de error
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Stock insuficiente'),
                      content: Text(mensajeError),
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
                  if (userData.addresses.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Sin direcciones'),
                        content: const Text('No tienes direcciones guardadas. ¿Quieres agregar una?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.push('/perfil/direcciones');
                              //bottomNavigationBar: const MainMenu();
                            },
                            child: const Text('Agregar dirección'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              
                            },
                            child: const Text('Cancelar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Selecciona una dirección'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: userData.addresses.map((address) {
                            return ListTile(
                              title: Text(address),
                              onTap: () {
                                
                                Navigator.of(context).pop();
                                _showConfirmationDialog(context, ref, cartPendiente, total, address);
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                }
              }
            },
            child: const Text('Comprar'),
          ),
        ],
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }

  
  void _showConfirmationDialog(BuildContext context, WidgetRef ref, CartPendiente cartPendiente, double total, String address) {
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
              onPressed: () async {
                final userData = ref.read(userProvider);
                final mail = userData.email;

                final newCart = Cart(
                  email: mail,
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  fechaCompra: DateTime.now(),
                  items: List.from(cartPendiente.items),
                  total: total,
                  //direccion: address, // 
                );
              for (var item in newCart.items) {
                            
                            await  ref.read(candleProvider.notifier).updateCandleStockAfterPurchase(item.name, item.quantity);
               }
                var uuid = Uuid();
                String uniqueId = uuid.v4();
                final newOrder = UserOrder(cart: newCart, email: mail, id: uniqueId);

                ref.read(carritosProvider.notifier).addCart(newCart); 
                ref.read(orderProvider.notifier).addOrder(newOrder); 

                ref.read(cartPendienteProvider.notifier).clearCartPendiente(mail);

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
}



void _showRemoveItemDialog(BuildContext context, WidgetRef ref, String itemId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Eliminar artículo'),
        content: const Text('¿Estás seguro de que quieres eliminar este artículo del carrito?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  
              ref.read(cartPendienteProvider.notifier).decreaseQuantity(itemId);  
            },
            child: const Text('Sí'),
          ),
        ],
      );
    },
  );
}