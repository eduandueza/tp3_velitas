import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_provider.dart';

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth;
  final Ref ref; 
  
  AuthNotifier(this._auth, this.ref) : super(null) {
    _auth.authStateChanges().listen((user) {
      state = user;
      if (user == null) {
        ref.read(userProvider.notifier).logout();
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error de inicio de sesión: $e");
      throw e;
    }
  }

    Future<bool> verificarLogin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Ingreso exitoso
    } catch (e) {
      print("Error de inicio de sesión: $e");
      return false; // Falla en el inicio de sesión
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error de registro: $e");
      throw e;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    ref.read(userProvider.notifier).logout(); 
  }

  String? getUid() {
    return state?.uid;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(FirebaseAuth.instance, ref);
});
