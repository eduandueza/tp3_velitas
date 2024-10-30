class UserData {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final List<String> addresses;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.addresses = const [],
  });

  
  UserData copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    List<String>? addresses,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      addresses: addresses ?? this.addresses,
    );
  }
}