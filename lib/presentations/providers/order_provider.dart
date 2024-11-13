import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../OrderStateEnum.dart';



class OrderNotifier extends StateNotifier<List<UserOrder>> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  OrderNotifier() : super([]);

   void addOrder(UserOrder order) async {

    final UserOrder nuevoPedido = order;
    state = [...state, nuevoPedido];

    await db.collection('orders').add(nuevoPedido.toFirestoreMap());
  }

  

   Future<List<UserOrder>> getOrdersByEmail(String email) async {
  try {
    
    final querySnapshot = await db
        .collection('orders')
        .where('email', isEqualTo: email) 
        .get();

    
    final orders = querySnapshot.docs.map((doc) {
      return UserOrder.fromFirestoreMap(doc.data() as Map<String, dynamic>);
    }).toList();

    
    return orders;

  } catch (e) {
    print("Error al obtener las órdenes: $e");
    
    return [];
  }
}

Future<List<UserOrder>> getAllOrders() async {
  try {
    
    final querySnapshot = await db.collection('orders').get();

    
    final orders = querySnapshot.docs.map((doc) {
      return UserOrder.fromFirestoreMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return orders; 
  } catch (e) {
    print("Error al obtener todas las órdenes: $e");
    
    return [];
  }
}


  Future<void> updateOrderStatus(String orderId, OrderState nuevoEstado) async {
    try {
      
      final querySnapshot = await db
          .collection('orders')
          .where('id', isEqualTo: orderId)
          .limit(1)  
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;

        
        await doc.reference.update({
          'estado': nuevoEstado.toString(), 
        });

        
        state = state.map((order) {
          if (order.id == orderId) {
            return order.copyWith(estado: nuevoEstado);
          }
          return order;
        }).toList();
      }
    } catch (e) {
      print("Error al actualizar el estado de la orden: $e");
    }
  }

}

final orderProvider = StateNotifierProvider<OrderNotifier, List<UserOrder>>((ref) {
  return OrderNotifier();
});
