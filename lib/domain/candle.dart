class Candle {
  final String id; // idDocumento
  final String description;
  final String name;
  final double price;
  final String scentRef; // Referencia a la colección de scents
  final int stock;
  final String typeRef;


  Candle({
    required this.id,
    required this.description,
    required this.name,
    required this.price,
    required this.scentRef,
    required this.stock,
    required this.typeRef,
  });

  // Método para convertir un documento de Firestore a un objeto Candle
  factory Candle.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Candle(
      id: documentId, // Asigna el ID del documento
      description: data['description'] as String,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      scentRef: data['scent_ref'] as String,
      stock: data['stock'] as int,
      typeRef: data['type_ref'] as String,
    );
  }

  get candleTypeId => null;

  // Método para convertir un objeto Candle a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'name': name,
      'price': price,
      'scent_ref': scentRef,
      'stock': stock,
      'type_ref': typeRef,
    };
  }

  // Método para copiar el objeto Candle y cambiar el id
  Candle copyWith({String? id}) {
    return Candle(
      id: id ?? this.id, // Usa el id existente si no se proporciona uno nuevo
      description: description,
      name: name,
      price: price,
      scentRef: scentRef,
      stock: stock,
      typeRef: typeRef,
    );
  }
}
