import 'package:cloud_firestore/cloud_firestore.dart';

class CandleType {
  final String id; // ID del documento
  final String name;
  final String description;
  final String size;
  final bool active; // Campo para el borrado lógico
  final DocumentReference<Object?>? ref; // Hacer que ref sea opcional

  CandleType({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
    required this.active, // Añadimos el campo active
    this.ref, // Hacer que ref sea opcional
  });

  // Método para convertir un documento de Firestore en un objeto CandleType
  factory CandleType.fromFirestore(DocumentSnapshot doc) {
    return CandleType(
      id: doc.id,
      name: doc['name'] as String,
      description: doc['description'] as String,
      size: doc['size'] as String,
      active: doc['active'] as bool, // Obtenemos el campo active desde Firestore
      ref: doc.reference, // Obtenemos la referencia al documento
    );
  }

  // Método para convertir un objeto CandleType en un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'size': size,
      'active': active, // Incluimos el campo active
    };
  }

  // Método para crear una copia de un CandleType con nuevos valores
  CandleType copyWith({
    String? id, // Aseguramos que el campo 'id' esté presente en 'copyWith'
    String? name,
    String? description,
    String? size,
    bool? active,
    DocumentReference? ref, // Permitir que la referencia también se modifique
  }) {
    return CandleType(
      id: id ?? this.id, // Si no se pasa el 'id', usamos el actual
      name: name ?? this.name,
      description: description ?? this.description,
      size: size ?? this.size,
      active: active ?? this.active,
      ref: ref ?? this.ref, // Si no se pasa la referencia, usamos la actual
    );
  }
}
