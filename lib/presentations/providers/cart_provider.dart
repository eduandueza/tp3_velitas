
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/items/model_cart.dart';
import '../../core/router/items/modelo_carrito.dart';

class CartNotifier extends StateNotifier<List<Cart>> {
  CartNotifier() : super([]);

  void addCart(Cart cart) {
    state = [...state, cart];
    //agregar lo de fb
  }

  void deleteCart(String id) {
    state = state.where((cart) => cart.id != id).toList();
  }
   //agregar lo de fb 
}

/* Generador de datos simulados , esto se saca una vez hecho de lo FB
List<Cart> generarCarritosSimulados(int cantidad) {
  List<Cart> carritos = [];
  for (var i = 1; i <= cantidad; i++) {
    final items = [
      CartItem(name: 'Vela Aromática', price: 10.99, quantity: 2),
      CartItem(name: 'Vela de Cera de Abeja', price: 15.50, quantity: 1),
    ];
    final total = items.fold(
      0.0,
      (suma, item) => suma + (item.price * item.quantity),
    );
    carritos.add(Cart(
      id: 'CART_$i',
      fechaCompra: DateTime.now().subtract(Duration(days: Random().nextInt(30))),
      items: items,
      total: total,
    ));
  }
  return carritos;
}*/


/*final carritosProvider = StateNotifierProvider<CartNotifier, List<Cart>>((ref) {
  return CartNotifier();
}); esto deberia ir pero con firebase*/


// aca esta la version para la simulacion con datos en memoria
// se establece como provider pero esta mal , ya que carrito no deberias ser provider
// sino stateNotifierProvider, pero viene bien para el ejemplo de ahora hasta este 
// lo de FB

final carritosProvider = StateNotifierProvider<CartNotifier, List<Cart>>((ref) {
  return CartNotifier();
});
