import 'package:flutter_application_1/core/router/items/model_userData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<UserData> {
  UserNotifier() : super(UserData(
    id: "1", // Puedes generar un ID de forma dinámica o utilizar uno predeterminado
    name: "Juan Pérez",
    email: "juan.perez@email.com",
    photoUrl: "",
    addresses: [
      "Calle Falsa 123, Ciudad, País",
      "Avenida Siempre Viva 742, Ciudad, País",
    ],
  ));

  void addAddress(String address) {
    state = state.copyWith(addresses: [...state.addresses, address]);
  }

  void removeAddress(String address) {
    state = state.copyWith(addresses: state.addresses.where((a) => a != address).toList());
  }

  void editAddress(String oldAddress, String newAddress) {
    state = state.copyWith(addresses: state.addresses.map((a) => a == oldAddress ? newAddress : a).toList());
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserData>((ref) {
  return UserNotifier();
});