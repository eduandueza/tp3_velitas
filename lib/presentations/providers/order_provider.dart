<<<<<<< HEAD
=======
import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
>>>>>>> f5094bce007f32e6c7e2dc2b3cd8a8f43eec8415
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../OrderStateEnum.dart';
import '../../core/router/items/model_cart.dart';



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

  Future<void> loadOrdersByEmail(WidgetRef ref) async {
    final userData = ref.read(userProvider); // Obtenemos el UserData desde userProvider
    if (userData.email != null) {
      try {
        // Realizamos la consulta en Firestore para obtener los pedidos del usuario
        final querySnapshot = await db
            .collection('orders')
            .where('email', isEqualTo: userData.email) // Filtramos por el email del usuario
            .get();

        // Convertimos los documentos de Firestore en instancias de UserOrder
        final List<UserOrder> orders = querySnapshot.docs.map((doc) {
          final data = doc.data();
          final cart = Cart.fromFirestore(data['cart']); // Asegúrate de que Cart tenga el método fromFirestore
          final estado = OrderState.values.firstWhere(
              (e) => e.toString() == data['estado'],
              orElse: () => OrderState.EN_CURSO);
          return UserOrder(cart: cart, estado: estado);
        }).toList();

        // Actualizamos el estado de los pedidos en el provider
        state = orders;
      } catch (e) {
        print('Error al cargar los pedidos: $e');
      }
    }
  }
}


final orderProvider = StateNotifierProvider<OrderNotifier, List<UserOrder>>((ref) {
  return OrderNotifier();
});
