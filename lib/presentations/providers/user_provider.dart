import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart';
import 'package:flutter_application_1/presentations/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<UserData> {
  UserNotifier() : super(UserData.anonymous);
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Método para obtener todos los usuarios desde Firestore
  Future<List<UserData>> getAllUsers() async {
    try {
      final querySnapshot = await _db.collection('customers').get();
      final users = querySnapshot.docs.map((doc) {
        return UserData.fromFirebaseToCode2(doc.data());
      }).toList();

      return users;
    } catch (e) {
      print("Error al obtener los usuarios: $e");
      return [];
    }
    }
  
  void setUserData(UserData userData) {
    state = userData;
  }

  Future<void> removeUserByEmail(String email) async {
  try {
    
    final querySnapshot = await _db.collection('customers')
      .where('email', isEqualTo: email) 
      .get();

    
    if (querySnapshot.docs.isNotEmpty) {
      
      await querySnapshot.docs.first.reference.delete();
      print('Usuario eliminado con éxito.');
    } else {
      print('No se encontró un usuario con ese email.');
    }
  } catch (e) {
    print("Error al eliminar el usuario: $e");
  }
}

  
  void logout() {
    state = UserData.anonymous;
  }

  void addAddress(String address) {
    state = state.copyWith(addresses: [...state.addresses, address]);
  }

  void removeAddress(String address) {
    state = state.copyWith(addresses: state.addresses.where((a) => a != address).toList());
  }

  void editAddress(String oldAddress, String newAddress) {
    state = state.copyWith(addresses: state.addresses.map((a) => a == oldAddress ? newAddress : a).toList());
  }

  // Método para obtener las direcciones del usuario desde Firestore
  Future<List<String>> getUserAddresses(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null && data['addresses'] != null) {
        return List<String>.from(data['addresses']);
      }
    }
    return [];
  }

  
  Future<void> loadUserData(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('customers').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) {
        
        setUserData(UserData.fromFirebaseToCode(data, userId));
      }
    }
  }

  //Future<void> register()

 
  Future<void> createUserInFirestore({required String userId,required String name,required String email,String? photoUrl,}) async {
    final firestore = FirebaseFirestore.instance;

    // Crea una nueva instancia de `UserData`
    final newUser = UserData(
      id: userId,
      name: name,
      email: email,
      photoUrl: photoUrl ?? '', 
      rol: 'ADMIN',
    );

    try {
      
      await firestore.collection('customers').doc(userId).set(newUser.toFirebase());
      
    } catch (e) {
      print("Error al crear el usuario en Firestore: $e");
      throw e;
    }
  }



}


final userProvider = StateNotifierProvider<UserNotifier, UserData>((ref) {
  final authUser = ref.watch(authProvider);
  final userNotifier = UserNotifier();

  if (authUser != null) {
    
    userNotifier.loadUserData(authUser.uid);
  }

  return userNotifier;
});