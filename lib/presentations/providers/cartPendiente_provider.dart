import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';
import 'package:flutter_application_1/presentations/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/model_cartPendiente.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';

class CartPendienteNotifier extends StateNotifier<CartPendiente?> {
  final FirebaseFirestore db;
  final Ref ref;

  CartPendienteNotifier(this.db, this.ref) : super(null) {
    // Escucha los cambios en authProvider
    ref.listen<User?>(
      authProvider,
      (previous, next) {
        if (next != null) {
          // Si el usuario está autenticado, cargar el carrito pendiente
          _loadCartPendiente(next.email!);
        } else {
          // Si no hay usuario autenticado, limpia el carrito pendiente
          state = null;
        }
      },
    );
  }

  Future<void> _loadCartPendiente(String userEmail) async {
    
    final querySnapshot = await db.collection('cartPendientes')
          .where('mail_propietario', isEqualTo: userEmail)
          .get();

    try {
          
        if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        state = CartPendiente.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        // Si no existe, crea un carrito pendiente vacío
        final nuevoCarrito = CartPendiente(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fechaCompra: DateTime.now(),
          items: [],
          total: 0.0,
          mailPropietario: userEmail,
        );

      await db.collection('cartPendientes').doc(nuevoCarrito.id).set(nuevoCarrito.toFirestore());

       state = nuevoCarrito;
      }

    }catch (e){
      print('Error al cargar carrito pendiente: $e');
    } 
         
  }

  Future<void> clearCartPendiente() async {
  final userEmail = ref.read(authProvider)?.email;
  
  if (userEmail != null) {
    try {
      // Eliminamos el carrito actual de la base de datos
      final querySnapshot = await db.collection('cartPendientes')
          .where('mail_propietario', isEqualTo: userEmail)
          .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      // Creamos un nuevo carrito vacío
      final nuevoCarrito = CartPendiente(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fechaCompra: DateTime.now(),
        items: [],
        total: 0.0,
        mailPropietario: userEmail,
      );

      // Actualizamos el estado con el nuevo carrito vacío
      state = nuevoCarrito;

      // Guardamos el nuevo carrito en Firestore
      await db.collection('cartPendientes').doc(nuevoCarrito.id).set(nuevoCarrito.toFirestore());

    } catch (e) {
      print('Error al limpiar y crear nuevo carrito pendiente: $e');
    }
  } else {
    print('No se pudo limpiar el carrito: no hay un usuario autenticado.');
  }
}

  void increaseQuantity (String itemname){

  }

  void decreaseQuantity (String itemname){

  }

  Future<void> saveCartPendiente() async {
    if (state != null) {
      try {
        final docRef = db.collection('cartPendientes').doc(state!.id);
        await docRef.set(state!.toFirestore());
      } catch (e) {
        print('Error al guardar carrito pendiente: $e');
      }
    } else {
      print('El carrito pendiente está vacío, no se puede guardar.');
    }
  }

  Future<void> addItemToCartPendiente(CartItem item) async {
    if (state != null) {
      state!.items.add(item);
      state = state!.copyWith(items: List.from(state!.items), total: _calculateTotal());
      await updateCartPendienteInFirestore();
    }else{
      print("EL CART ES NULOOOOOOOOOO");
      print("EL CART ES NULOOOOOOOOOO");
      
      print("EL CART ES NULOOOOOOOOOO");
      print("EL CART ES NULOOOOOOOOOO");
      print("EL CART ES NULOOOOOOOOOO");
      print("EL CART ES NULOOOOOOOOOO");
    }

  }

  Future<void> updateCartPendienteInFirestore() async {
    if (state != null) {
      try {
        final docRef = db.collection('cartPendientes').doc(state!.id);
        await docRef.set(state!.toFirestore());
      } catch (e) {
        print('Error al actualizar carrito pendiente en Firestore: $e');
      }
    }
  }



  double _calculateTotal() {
    return state?.items.fold(0.0, (sum, item) {
      sum = (sum==null) ? 0.0:sum;
      final itemPrice = item.price ?? 0.0;
      final itemQuantity = item.quantity ?? 0;
      return sum + (itemPrice * itemQuantity);
    }) ?? 0.0;
  }
}

// Define el CartPendienteProvider, que es un provider de tipo StateNotifierProvider
final cartPendienteProvider = StateNotifierProvider<CartPendienteNotifier, CartPendiente?>(
  (ref) => CartPendienteNotifier(FirebaseFirestore.instance, ref),
);