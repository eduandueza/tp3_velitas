import 'package:flutter/material.dart';

import '../../../OrderStateEnum.dart';
import '../../../core/router/items/model_cart.dart';

class UserOrder {
  final Cart cart;
  final OrderState estado;

  UserOrder({
    required this.cart,
    this.estado = OrderState.EN_CURSO,
  });

  Color get color {
    switch (estado) {
      case OrderState.ENTREGADO:
        return Colors.green;
      case OrderState.EN_CURSO:
        return Colors.blueAccent;
      case OrderState.CANCELADO:
        return Colors.red;
      default:
        return Colors.purple;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'cart': cart.toMap(), // Necesitas un método `toMap()` en `Cart`
      'estado': estado.toString().split('.').last, // Guarda el estado como string
    };
  }

  UserOrder copyWith({OrderState? estado}) {
    return UserOrder(
      cart: cart,
      estado: estado ?? this.estado,
    );
  }

  // Método para convertir la orden a un mapa compatible con Firestore
  Map<String, dynamic> toFirestoreMap() {
    return {
      'cart': cart.toFirestore(), // Asegúrate de que `Cart` también tenga un método similar
      'estado': estado.toString(), // Convierte `estado` a un string para Firestore
    };
  }
  
/*
  // Método para crear un `UserOrder` desde un documento de Firestore (opcional)
  factory UserOrder.fromFirestoreMap(Map<String, dynamic> map) {
    return UserOrder(
      cart: Cart.fromFirestore(map['cart']), // Asegúrate de que `Cart` tenga `fromFirestoreMap`
      estado: OrderState.values.firstWhere(
        (e) => e.toString() == map['estado'],
        orElse: () => OrderState.EN_CURSO,
      ),
    );
  }
*/

}

