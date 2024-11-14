class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  factory CartItem.fromMap(Map<String, dynamic> data, String documentId) {
   
   try {
     return CartItem(
      id: documentId,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] as int,
    );
   } catch (e){
     throw Exception("Error al deserializar el CARTITEM: $e");
   }
   
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  
  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
