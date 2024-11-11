import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

class CartPendiente {
  final String id;
  final DateTime fechaCompra;
  final List<CartItem> items;
  final double total;
  final String? mailPropietario;

  CartPendiente({
    required this.id,
    required this.fechaCompra,
    required this.items,
    required this.total,
    this.mailPropietario,
  });

  // Método para convertir un documento de Firestore a un objeto CartPendiente
  factory CartPendiente.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CartPendiente(
      id: documentId,
      fechaCompra: (data['fecha_compra'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>).map((itemData) {
        return CartItem.fromMap(itemData as Map<String, dynamic>, itemData['id'] as String);
      }).toList(),
      total: (data['total'] as num).toDouble(),
      mailPropietario: data['mail_propietario'] as String?, // Si existe
    );
  }

  // Método para convertir un objeto CartPendiente a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fecha_compra': Timestamp.fromDate(fechaCompra),
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'mail_propietario': mailPropietario, // Puede ser nulo
    };
  }

  // Método para copiar el objeto CartPendiente y cambiar el ID, items, total o mailPropietario si es necesario
  CartPendiente copyWith({
    String? id,
    String? mailPropietario,
    List<CartItem>? items,
    double? total,
  }) {
    return CartPendiente(
      id: id ?? this.id,
      fechaCompra: fechaCompra,
      items: items ?? this.items,
      total: total ?? this.total,
      mailPropietario: mailPropietario ?? this.mailPropietario,
    );
  }
}