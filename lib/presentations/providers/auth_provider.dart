import 'package:flutter_riverpod/flutter_riverpod.dart';

// NO TIENE FIREBASE
final authProvider = StateNotifierProvider<AuthNotifier, bool>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false); 

  void logIn(String email, String password) {
    if (email == "test@aaaa.com" && password == "mati") {
      state = true; 
    } else {
      
      print('Credenciales incorrectas');
    }
  }

  void logOut() {
    state = false; 
  }
}
