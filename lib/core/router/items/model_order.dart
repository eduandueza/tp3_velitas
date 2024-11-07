import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_cart.dart';

import '../../../OrderStateEnum.dart';


class Order {
  final Cart cart;
  final OrderState estado;

  Order({
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

  
  Order copyWith({OrderState? estado}) {
    return Order(
      cart: cart,
      estado: estado ?? this.estado,
    );
  }}
