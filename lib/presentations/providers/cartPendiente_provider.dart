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

  CartPendienteNotifier(this.db, this.ref) : super(null);

  Future<void> loadCartPendiente(String userEmail) async {
    
    print ("el email recibido por loadCartPendiente , es : "+userEmail);
    
    try {

      final querySnapshot = await db.collection('cartPendientes')
          .where('mail_propietario', isEqualTo: userEmail)
          .get();
          
        if (querySnapshot.docs.isNotEmpty) {

       print(" el querySnapshot TIENE ALGO ");
       print(" el querySnapshot TIENE ALGO ");

        final doc = querySnapshot.docs.first;
        state = CartPendiente.fromFirestore2(doc.data() as Map<String, dynamic>);

      print ("SE CARGO CON EXITO EL CARRITO PENDIENTE DE LA BD");
      print ("SE CARGO CON EXITO EL CARRITO PENDIENTE DE LA BD");
      print ("SE CARGO CON EXITO EL CARRITO PENDIENTE DE LA BD");
      print ("SE CARGO CON EXITO EL CARRITO PENDIENTE DE LA BD");
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

       print ("SE CARGO CON EXITO EL CARRITO PENDIENTE NUEVO");
      print ("SE CARGO CON EXITO EL CARRITO PENDIENTE NUEVO");
      print ("SE CARGO CON EXITO EL CARRITO PENDIENTE NUEVO");
      print ("SE CARGO CON EXITO EL CARRITO PENDIENTE NUEVO");

      }
     


    }catch (e){
      print('Error al cargar carrito pendiente: $e');
    } 
         
  }

   Future<void> clearCartPendiente(String userEmail) async {
  try {
    // Obtener el carrito pendiente actual desde Firestore
    final querySnapshot = await db.collection('cartPendientes')
        .where('mail_propietario', isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;

      // Actualizar el estado del carrito vacío
      final updatedCart = state?.copyWith(items: [], total: 0.0); // Vaciar los items y resetear el total
      state = updatedCart; // Actualizar el estado del carrito

      // Subir el carrito vacío a Firestore
      await db.collection('cartPendientes').doc(doc.id).set(updatedCart!.toFirestore());

      print('Carrito vacío actualizado en Firestore.');
    } else {
      print('No se encontró un carrito pendiente para el usuario con el email $userEmail.');
    }
  } catch (e) {
    print('Error al limpiar el carrito pendiente: $e');
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