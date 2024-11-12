import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

class Cart {
  final String id; // ID del documento en Firestore
  final DateTime fechaCompra;
  final List<CartItem> items;
  final double total;
  final String email; // Añadido campo email

  Cart({
    required this.id,
    required this.fechaCompra,
    required this.items,
    required this.total,
    required this.email, // Inicialización del campo email
  });

  // Método para convertir un documento de Firestore a un objeto Cart
  factory Cart.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Cart(
      id: documentId,
      fechaCompra: (data['fecha_compra'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>).map((itemData) {
        return CartItem.fromMap(itemData as Map<String, dynamic>, itemData['id'] as String);
      }).toList(),
      total: (data['total'] as num).toDouble(),
      email: data['email'] ?? '', // Agregar el campo 'email' (si existe)
    );
  }

 factory Cart.fromFirestore2(Map<String, dynamic> data) {
  try {
    // 1. Verificar si el objeto 'data' es nulo
    if (data == null) {
      throw Exception("El objeto 'data' recibido es nulo");
    }
    
    String emailee= data['email'] ?? 'NO HAY EMAIL ASIGNADO';

    print ("ESTE ES EL EMAIL QUE HAY "+ emailee);

   
    // 4. Deserializar los campos
    return Cart(
      email: data['email'] ?? 'No disponible', // Si 'email' no está presente, se usa un valor por defecto
      id: data['id'] ?? 'random',  // Si 'id' no está presente, se usa un valor por defecto
      fechaCompra: (data['fecha_compra'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>).map((itemData) {
        return CartItem.fromMap(itemData as Map<String, dynamic>, itemData['id'] as String);
      }).toList(),
      total: (data['total'] as num).toDouble(),
    );
  } catch (e) {
    // 5. Manejar errores de deserialización
    print("Error al deserializar el carrito: $e");
    // Puedes devolver un carrito vacío o manejar el error de otra manera
    return Cart(email: 'No disponible', id: 'random', fechaCompra: DateTime.now(), items: [], total: 0);
  }
}

  // Método para convertir un objeto Cart a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fecha_compra': Timestamp.fromDate(fechaCompra),
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'email': email, // Incluimos el campo email en Firestore
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // ID del carrito
      'fecha_compra': fechaCompra, // Fecha de compra (DateTime)
      'items': items.map((item) => item.toMap()).toList(), // Convierte los CartItems a Map
      'total': total, // Total de la compra
      'email': email, // Email del usuario asociado al carrito
    };
  }

  Cart copyWith({String? id, String? email}) {
    return Cart(
      id: id ?? this.id,
      fechaCompra: fechaCompra,
      items: items,
      total: total,
      email: email ?? this.email, // Permite actualizar el email
    );
  }
}




/*  factory Cart.fromFirestore(Map<String, dynamic> data, String documentId) {
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

  factory Cart.fromFirestore2(Map<String, dynamic> data) {
  try {
    return Cart(
      id: data['id'],
      fechaCompra: (data['fecha_compra'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>).map((itemData) {
        return CartItem.fromMap(itemData as Map<String, dynamic>, itemData['id'] as String);
      }).toList(),
      total: (data['total'] as num).toDouble(),
    );
  } catch (e) {
    print("Error al deserializar el carrito: $e");
    // Puedes devolver un carrito vacío o manejar el error de otra manera
    throw Exception("Error al deserializar el carrito");
  }
}

  toMap() {}


*/ 