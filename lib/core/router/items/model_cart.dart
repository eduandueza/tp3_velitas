import 'package:flutter_application_1/core/router/items/modelo_carrito.dart';

class Cart {
  final String id;
  final DateTime fechaCompra;
  final List<CartItem> items;
  final double total;

  Cart({
    required this.id,
    required this.fechaCompra,
    required this.items,
    required this.total,
  });
}