import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../OrderStateEnum.dart';



class OrderNotifier extends StateNotifier<List<UserOrder>> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  OrderNotifier() : super([]);

   void addOrder(UserOrder order) async {


    final UserOrder nuevoPedido = order;

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
