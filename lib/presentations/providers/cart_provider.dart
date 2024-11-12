import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/router/items/model_cart.dart';

final carritosProvider = StateNotifierProvider<CartNotifier, List<Cart>>(
  (ref) => CartNotifier(FirebaseFirestore.instance),
);

class CartNotifier extends StateNotifier<List<Cart>> {
  final FirebaseFirestore db;

  CartNotifier(this.db) : super([]) {
    getAllCarts();
  }

  Future<void> addCart(Cart cart) async {
    final docRef = db.collection('cart').doc();
    try {
      final newCart = cart.copyWith(id: docRef.id);
      await docRef.set(newCart.toFirestore()); // TOCASTE ACA deberia poner antes el newCart
      state = [...state, newCart]; // Agrega el nuevo carrito al estado
    } catch (e) {
      print(e);
      print("ERROR CONEXIÓN FIREBASE al agregar carrito");
    }
  }

  Future<void> deleteCart(String id) async {
    try {
      await db.collection('cart').doc(id).delete();
      state = state.where((cart) => cart.id != id).toList();
    } catch (e) {
      print(e);
      print("ERROR CONEXIÓN FIREBASE al eliminar carrito");
    }
  }

  Future<void> getAllCarts() async {
    try {
      final querySnapshot = await db.collection('cart').get();
      state = querySnapshot.docs.map((doc) {
        return Cart.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print(e);
    }
  }
}
