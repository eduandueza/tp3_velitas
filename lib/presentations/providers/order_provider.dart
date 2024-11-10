import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../OrderStateEnum.dart';
import '../../core/router/items/model_cart.dart';



class OrderNotifier extends StateNotifier<List<UserOrder>> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  OrderNotifier() : super([]);

   void addOrder(Cart cart) async {
    final UserOrder nuevoPedido = UserOrder(cart: cart, estado: OrderState.EN_CURSO);

    // Agregar a la lista local
    state = [...state, nuevoPedido];

    // Convertir la orden a un mapa y guardarla en Firestore
    await db.collection('orders').add(nuevoPedido.toFirestoreMap());
  }

  void updateOrderStatus(String cartId, OrderState nuevoEstado) {
    // Aquí podrías implementar la lógica para actualizar el estado de un pedido en Firestore si es necesario
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<UserOrder>>((ref) {
  return OrderNotifier();
});
