
import 'package:flutter_application_1/core/router/items/modelo_carrito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final existingItem = state.firstWhere(
      (cartItem) => cartItem.name == item.name,
      orElse: () => CartItem(name: '', price: 0), 
    );

    if (existingItem.name.isNotEmpty) {
      // Si el item ya existe, solo aumenta la cantidad
      existingItem.quantity++;
      state = [...state]; // Actualiza el estado
    } else {
      state = [...state, item]; // Agrega el nuevo item
    }
  }

  void removeItem(String itemName) {
    state = state.where((item) => item.name != itemName).toList();
  }

  double get total => state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});