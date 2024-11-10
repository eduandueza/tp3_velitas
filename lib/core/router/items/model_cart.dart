import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

class Cart {
  final String id; // ID del documento en Firestore
  final DateTime fechaCompra;
  final List<CartItem> items;
  final double total;

  Cart({
    required this.id,
    required this.fechaCompra,
    required this.items,
    required this.total,
  });

  // Método para convertir un documento de Firestore a un objeto Cart
  factory Cart.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Cart(
      id: documentId,
      fechaCompra: (data['fecha_compra'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>).map((itemData) {
        // Asegúrate de manejar correctamente los datos de los items
        return CartItem.fromMap(itemData as Map<String, dynamic>, itemData['id'] as String);
      }).toList(),
      total: (data['total'] as num).toDouble(),
    );
  }

  // Método para convertir un objeto Cart a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fecha_compra': Timestamp.fromDate(fechaCompra),
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
    };
  }

  // Método para copiar el objeto Cart y cambiar el ID si es necesario
  Cart copyWith({String? id}) {
    return Cart(
      id: id ?? this.id,
      fechaCompra: fechaCompra,
      items: items,
      total: total,
    );
  }

  toMap() {}
}
