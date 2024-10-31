

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../OrderStateEnum.dart';
import '../../core/router/items/model_cart.dart';
import '../../core/router/items/model_order.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  
  void addOrder(Cart cart) {
    final nuevoPedido = Order(cart: cart, estado: OrderState.EN_CURSO);
    state = [...state, nuevoPedido];
  }

  
  void updateOrderStatus(String cartId, OrderState nuevoEstado) {
   
  }

  
}


final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});