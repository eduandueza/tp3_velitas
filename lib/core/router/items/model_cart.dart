import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

class Cart {
  final String id; 
  final DateTime fechaCompra;
  final List<CartItem> items;
  final double total;
  final String email; 

  Cart({
    required this.id,
    required this.fechaCompra,
    required this.items,
    required this.total,
    required this.email, 
  });

  
  factory Cart.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Cart(
      id: documentId,
      fechaCompra: (data['fecha_compra'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>).map((itemData) {
        return CartItem.fromMap(itemData as Map<String, dynamic>, itemData['id'] as String);
      }).toList(),
      total: (data['total'] as num).toDouble(),
      email: data['email'] ?? '', 
    );
  }

 factory Cart.fromFirestore2(Map<String, dynamic> data) {
  try {
    
    if (data == null) {
      throw Exception("El objeto 'data' recibido es nulo");
    }

    
    String emailee = data['email'] ?? 'NO HAY EMAIL ASIGNADO';
    print("ESTE ES EL EMAIL QUE HAY: $emailee");

    
    if (data['fecha_compra'] == null) {
      throw Exception("El campo 'fecha_compra' es nulo");
    }
    if (data['items'] == null) {
      throw Exception("El campo 'items' es nulo");
    }
    if (data['total'] == null) {
      throw Exception("El campo 'total' es nulo");
    }

   
    if (data['fecha_compra'] is! Timestamp) {
      throw Exception("El campo 'fecha_compra' no es del tipo Timestamp");
    }

    
    if (data['items'] is! List) {
      throw Exception("El campo 'items' no es una lista");
    }

    
    if (data['total'] is! num) {
      throw Exception("El campo 'total' no es un número");
    }

    
    return Cart(
      email: data['email'] ?? 'No disponible',  
      id: "",  
      fechaCompra: (data['fecha_compra'] as Timestamp).toDate(),  
      items: (data['items'] as List<dynamic>).map((itemData) {
       
        return CartItem.fromMap(itemData as Map<String, dynamic>, "pepe"); // aca puede ser , como te odio flutter
      }).toList(),
      total: (data['total'] as num).toDouble(),  
    );
  } catch (e) {
    
    print("Error al deserializar el carrito: $e");

  
    return Cart(email: 'No disponible', id: 'random', fechaCompra: DateTime.now(), items: [], total: 0);
  }
}

  Map<String, dynamic> toFirestore() {
    return {
      'fecha_compra': Timestamp.fromDate(fechaCompra),
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'email': email, 
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'fecha_compra': fechaCompra, 
      'items': items.map((item) => item.toMap()).toList(), 
      'total': total, 
      'email': email, 
    };
  }

  Cart copyWith({String? id, String? email}) {
    return Cart(
      id: id ?? this.id,
      fechaCompra: fechaCompra,
      items: items,
      total: total,
      email: email ?? this.email, 
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