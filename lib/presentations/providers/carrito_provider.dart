import 'package:flutter_application_1/core/router/items/modelo_carrito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

// Dentro de la clase CartNotifier en carrito_provider.dart


  void addItem(CartItem item) {
    final existingItem = state.firstWhere(
      (cartItem) => cartItem.name == item.name,
      orElse: () => CartItem(name: '', price: 0), 
    );

    if (existingItem.name.isNotEmpty) {
      existingItem.quantity++;
      state = [...state];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String itemName) {
    state = state.where((item) => item.name != itemName).toList();
  }

  void increaseQuantity(String itemName) {
    final index = state.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      state[index].quantity++;
      state = [...state];
    }
  }

  void decreaseQuantity(String itemName) {
    final index = state.indexWhere((item) => item.name == itemName);
    if (index != -1 && state[index].quantity > 1) {
      state[index].quantity--;
    } else if (index != -1) {
      // Si la cantidad es 1, elimina el producto
      removeItem(itemName);
    }
    state = [...state];
  }

  int get totalItemsCount {
    return state.fold(0, (sum, item) => sum + item.quantity);
}
// vaciar carrito
  void clearCart() {
    state = []; 
  }

  double get total => state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}



final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});