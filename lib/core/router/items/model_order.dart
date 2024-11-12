import 'package:flutter/material.dart';

import '../../../OrderStateEnum.dart';
import '../../../core/router/items/model_cart.dart';

class UserOrder {
  final Cart cart;
  final OrderState estado;
  final String email;

  UserOrder({
    required this.cart,
    this.estado = OrderState.EN_CURSO,
    required this.email,
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

  Map<String, dynamic> toMap(String a,int b) {
    return {
      'cart': cart.toMap(), // Necesitas un método `toMap()` en `Cart` //ACA ROMPEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE METODO TO MAP
      'estado': estado.toString().split('.').last, // guarda el estado como string
      'email': email,
    };
  }

  UserOrder copyWith({OrderState? estado}) {
    return UserOrder(
      cart: cart,
      estado: estado ?? this.estado,
      email: email ?? this.email,
    );
  }

  factory UserOrder.fromFirestoreMap(Map<String, dynamic> map) {
  try {
    print("Datos de cart recibidos: ${map['cart']}");
    print("Datos de cart recibidos: ${map['cart']}");
    print("Datos de cart recibidos: ${map['cart']}");
    return UserOrder(
      cart: Cart.fromFirestore2(map['cart']), 
      estado: OrderState.values.firstWhere(
        (e) => e.toString() == map['estado'],
        orElse: () => OrderState.EN_CURSO, 
      ),
      email: map['email'], 
    );
  } catch (e) {
    print("Error al deserializar la orden: $e");
    
    throw Exception("Error al deserializar la orden");
  }
}


  
  Map<String, dynamic> toFirestoreMap() {
    return {
      'cart': cart.toFirestore(), 
      'estado': estado.toString(), 
      'email': email,
    };
  }


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