import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth;

  AuthNotifier(this._auth) : super(null) {
    // escucha el estado del usuario actual en Firebase
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
    } catch (e) {
      print("Error de inicio de sesion: $e");
      throw e;
    }
  }

  
   Future<void> register(String email, String password) async {
    try {
    
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    //print("Usuario creado: ${userCredential.user?.uid}"); // Verifica que el usuario se creó correctamente
    
  } catch (e,stackTrace) {
    print("Error de registro, FALLO EN EL AUTH AQQUI2: $e");
    print("Detalles del error: $stackTrace");
    throw e;
  }
  }

  
  Future<void> logout() async {
    await _auth.signOut();
  }

  String? getUid() {
    return state?.uid; 
  }
}


final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(FirebaseAuth.instance);
});
