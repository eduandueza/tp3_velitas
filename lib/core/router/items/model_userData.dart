class UserData {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final List<String> addresses;
  final String rol;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.addresses = const [],
    required this.rol
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
      rol: rol ?? this.rol
    );
  }


static UserData anonymous = UserData(
  id: '12345',
  name: 'Juan Pérez',
  email: 'juan.perez@ejemplo.com',
  photoUrl: 'https://static.wixstatic.com/media/af1176_cd1cc93602cf465fa5e78b3146f4c505~mv2.jpg/v1/fill/w_560,h_840,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/IMG_6044_JPG.jpg',
  addresses: [
    'Calle Falsa 123, Ciudad, País',
    'Avenida Siempre Viva 742, Ciudad, País'
  ],
  rol: 'USUARIO',
  );

 factory UserData.fromFirebaseToCode(Map<String, dynamic> data, String userId) {
    return UserData(
      id: userId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      addresses: List<String>.from(data['addresses'] ?? []),
      rol: data['rol'] ?? 'USUARIO',
    );
  }

  factory UserData.fromFirebaseToCode2(Map<String, dynamic> data) {
    return UserData(
      id: "pepe",
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: '',
      addresses: [],
      rol: data['rol'] ?? 'USUARIO',
    );
  }

  
  Map<String, dynamic> toFirebase() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'rol': rol,
    };
  }

  Map<String, dynamic> toFirebaseWithAddresses() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'rol': rol,
      'addresses':addresses
    };
  }

}