import 'package:cloud_firestore/cloud_firestore.dart';

class Candle {
  final String id; // idDocumento
  final String description;
  final String name;
  final double price;
  final DocumentReference scentRef; // Referencia a la colección de scents
  final int stock;
  final DocumentReference typeRef; // Referencia a la colección de tipos
  final String? imageUrl; // Nueva propiedad opcional para la imagen

  Candle({
    required this.id,
    required this.description,
    required this.name,
    required this.price,
    required this.scentRef,
    required this.stock,
    required this.typeRef,
    this.imageUrl, // Puede ser null si aún no se ha subido la imagen
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
      typeRef: data['type_ref'] as DocumentReference, // Cambiado a DocumentReference
      imageUrl: data['image_url'] as String?, // Carga el campo imageUrl
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
      'type_ref': typeRef, // Almacena como DocumentReference
      'image_url': imageUrl, // Guarda el campo imageUrl
    };
  }

  // Método para copiar el objeto Candle y cambiar el id o la imageUrl
  Candle copyWith({String? id, String? imageUrl}) {
    return Candle(
      id: id ?? this.id,
      description: description,
      name: name,
      price: price,
      scentRef: scentRef,
      stock: stock,
      typeRef: typeRef,
      imageUrl: imageUrl ?? this.imageUrl, // Copia la imageUrl si no se proporciona una nueva
    );
  }
}
