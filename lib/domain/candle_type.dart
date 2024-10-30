class CandleType {
  final String id;
  final String name;
  final String description;
  final String size;

  CandleType({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
  });

  factory CandleType.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CandleType(
      id: documentId,
      name: data['name'] as String,
      description: data['description'] as String,
      size: data['size'] as String,
    );
  }
}
