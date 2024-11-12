import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../OrderStateEnum.dart';
import '../../core/router/items/model_cart.dart';



class OrderNotifier extends StateNotifier<List<UserOrder>> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  OrderNotifier() : super([]);

   void addOrder(UserOrder order) async {

    final UserOrder nuevoPedido = order;
    state = [...state, nuevoPedido];

    await db.collection('orders').add(nuevoPedido.toFirestoreMap());
  }

   Future<void> getOrdersByEmail(String email) async {
    try {
      final querySnapshot = await db
          .collection('orders')
          .where('email', isEqualTo: email) // Filtramos por email
          .get();

      // Convertir los documentos obtenidos a objetos UserOrder
      final orders = querySnapshot.docs.map((doc) {
        return UserOrder.fromFirestoreMap(doc.data() as Map<String, dynamic>);
      }).toList();

      // Actualizar el estado con las órdenes encontradas
      state = orders;

    } catch (e) {
      print("Error al obtener las órdenes: $e");
      // Si hay error, podemos dejar el estado vacío o manejar el error de otra manera
      state = [];
    }
  }


  void updateOrderStatus(String cartId, OrderState nuevoEstado) {
    // Aquí podrías implementar la lógica para actualizar el estado de un pedido en Firestore si es necesario
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<UserOrder>>((ref) {
  return OrderNotifier();
});
