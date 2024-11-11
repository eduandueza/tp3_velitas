import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

class CartItemProvider extends StateNotifier<List<CartItem>> {
  final FirebaseFirestore db;

  CartItemProvider(this.db) : super([]);

  // Cargar el carrito desde Firestore
  Future<void> loadCart() async {
    try {
      final querySnapshot = await db.collection('cartItem').get();
      state = querySnapshot.docs.map((doc) {
        return CartItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error al cargar el carrito: $e');
    }
  }

  Future<void> addItem(CartItem item) async {
    try {
      final existingItemIndex = state.indexWhere((cartItem) => cartItem.id == item.id);

      if (existingItemIndex != -1) {
        state[existingItemIndex].quantity++;
        state = [...state];
        await _updateItemInFirestore(state[existingItemIndex]);
      } else {
        final docRef = await db.collection('cartItem').add(item.toMap());
        state = [...state, item.copyWith(id: docRef.id)];
      }
    } catch (e) {
      print('Error al agregar item al carrito: $e');
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      final itemToRemove = state.firstWhere((item) => item.id == itemId);
      state = state.where((item) => item.id != itemId).toList();
      await db.collection('cartItem').doc(itemId).delete();
    } catch (e) {
      print('Error al eliminar item del carrito: $e');
    }
  }

  Future<void> _updateItemInFirestore(CartItem item) async {
    try {
      await db.collection('cartItem').doc(item.id).update(item.toMap());
    } catch (e) {
      print('Error al actualizar item en Firestore: $e');
    }
  }

  Future<void> increaseQuantity(String itemId) async {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      state[index].quantity++;
      state = [...state];
      await _updateItemInFirestore(state[index]);
    }
  }

  Future<void> decreaseQuantity(String itemId) async {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1 && state[index].quantity > 1) {
      state[index].quantity--;
      await _updateItemInFirestore(state[index]);
    } else if (index != -1) {
      await removeItem(itemId);
    }
    state = [...state];
  }

  Future<void> clearCart() async {
    try {
      final querySnapshot = await db.collection('cartItem').get();
      for (var doc in querySnapshot.docs) {
        await db.collection('cartItem').doc(doc.id).delete();
      }
      state = [];
    } catch (e) {
      print('Error al vaciar el carrito: $e');
    }
  }

  double get total => state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

final carritoProvider = StateNotifierProvider<CartItemProvider, List<CartItem>>((ref) {
  return CartItemProvider(FirebaseFirestore.instance);
});
