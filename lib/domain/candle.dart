import 'package:cloud_firestore/cloud_firestore.dart';

class Candle {
  final String id; // idDocumento
  final String description;
  final String name;
  final double price;
  final DocumentReference scentRef; // Referencia a la colección de scents
  final int stock;
  final DocumentReference? typeRef; // Ahora es opcional
  final String? imageUrl; // Nueva propiedad opcional para la imagen
  final bool active;

  Candle({
    required this.id,
    required this.description,
    required this.name,
    required this.price,
    required this.scentRef,
    required this.stock,
    this.typeRef, // Lo hacemos opcional, por eso no es requerido
    this.imageUrl, // Puede ser null si aún no se ha subido la imagen
    required this.active
  });

  // Método para convertir un documento de Firestore a un objeto Candle
  factory Candle.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Candle(
      id: documentId,
      description: data['description'] as String,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      scentRef: data['scent_ref'] as DocumentReference, // Cambiado a DocumentReference
      stock: data['stock'] as int,
      typeRef: data['type_ref'] != null
        ? data['type_ref'] as DocumentReference
        : null, // Si no existe el campo, se asigna null
      imageUrl: data['image_url'] as String?, // Carga el campo imageUrl
      active: data['active'] as bool
    );
  }

  // Método para convertir un objeto Candle a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'name': name,
      'price': price,
      'scent_ref': scentRef, // Almacena como DocumentReference
      'stock': stock,
      'type_ref': typeRef, // Guarda como DocumentReference o null si es opcional
      'image_url': imageUrl, // Guarda el campo imageUrl
      'active': active
    };
  }

  
 // Método para copiar el objeto Candle y cambiar el id, stock, imageUrl, active o typeRef
  Candle copyWith({
    String? id,
    int? stock,
    String? imageUrl,
    bool? active,
    DocumentReference? typeRef, // Ahora es posible modificar typeRef también
  }) {
    return Candle(
      id: id ?? this.id, // Si no se pasa un id, mantiene el actual
      description: description,
      name: name,
      price: price,
      scentRef: scentRef,
      stock: stock ?? this.stock, // Si no se pasa un stock, mantiene el actual
      typeRef: typeRef ?? this.typeRef, // Si no se pasa un typeRef, mantiene el actual
      imageUrl: imageUrl ?? this.imageUrl, // Si no se pasa un imageUrl, mantiene el actual
      active: active ?? this.active, // Si no se pasa un active, mantiene el actual
    );
  }


  
}
