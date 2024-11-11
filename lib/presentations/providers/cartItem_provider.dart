import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

class CartItemProvider extends StateNotifier<List<CartItem>> {
  CartItemProvider() : super([]);

  // Agregar un item al carrito
  void addItem(CartItem item) {
    final existingItemIndex = state.indexWhere((cartItem) => cartItem.id == item.id);
    
    if (existingItemIndex != -1) {
      state[existingItemIndex].quantity++;
      state = [...state];
    } else {
      state = [...state, item];
    }
  }

  // Eliminar un item del carrito
  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  // Aumentar la cantidad de un item
  void increaseQuantity(String itemId) {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      state[index].quantity++;
      state = [...state];
    }
  }

  // Disminuir la cantidad de un item
  void decreaseQuantity(String itemId) {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1 && state[index].quantity > 1) {
      state[index].quantity--;
      state = [...state];
    } else if (index != -1) {
      removeItem(itemId);
    }
  }

  // Vaciar el carrito
  void clearCart() {
    state = [];
  }

  // Obtener el total del carrito
  double get total => state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

final carritoProvider = StateNotifierProvider<CartItemProvider, List<CartItem>>((ref) {
  return CartItemProvider();
});
