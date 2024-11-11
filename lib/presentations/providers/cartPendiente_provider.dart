import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/router/items/model_cartPendiente.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';

final cartPendienteProvider = StateNotifierProvider<CartPendienteNotifier, CartPendiente?>(
  (ref) => CartPendienteNotifier(FirebaseFirestore.instance, ref),
);

class CartPendienteNotifier extends StateNotifier<CartPendiente?> {
  final FirebaseFirestore db;
  final Ref ref;

  CartPendienteNotifier(this.db, this.ref) : super(null) {
    _loadCartPendiente();
  }

  Future<void> _loadCartPendiente() async {
    final user = ref.read(userProvider); // Obtenemos el usuario desde el provider
    if (user?.email != null) {
      try {
        final querySnapshot = await db.collection('cartPendientes').where('mail_propietario', isEqualTo: user!.email).get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          state = CartPendiente.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        } else {
          // Si no existe, se instancia un carrito pendiente vacío con el mailPropietario obligatorio
          state = CartPendiente(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fechaCompra: DateTime.now(),
            items: [],
            total: 0.0,
            mailPropietario: user.email!, // Asignamos el email del usuario
          );
        }
      } catch (e) {
        print('Error al cargar carrito pendiente: $e');
      }
    }
  }

  Future<void> saveCartPendiente() async {
  if (state != null) {
    try {
      // Referencia al documento en Firestore usando el ID del carrito pendiente
      final docRef = db.collection('cartPendientes').doc(state!.id);

      // Guardamos el carrito pendiente en Firestore
      await docRef.set(state!.toFirestore());

      // Actualizamos el estado con el carrito que hemos guardado (aunque ya es el mismo)
      state = state; // Aunque no es necesario, lo dejamos para claridad
    } catch (e) {
      print('error al guardar carrito pendiente: $e');
    }
  } else {
    print('el carrito pendiente está vacio no se puede guardar.');
  }
}

Future<void> _checkAndSaveEmptyCart() async {
  if (state!.items.isEmpty) {
    await saveCartPendiente();
    // Recargar el carrito desde Firestore para asegurar que el estado esté actualizado
    await _loadCartPendiente();
  }
}

  Future<void> addItemToCartPendiente(CartItem item) async { // FIJARTE ACA PARA QUE SE AÑADAN CARITEMS y no ITEMS
    if (state != null) {

      await _checkAndSaveEmptyCart();
      state!.items.add(item);
      state = state!.copyWith(items: List.from(state!.items), total: _calculateTotal());
      await _updateCartPendienteInFirestore();
    }
  }

  Future<void> removeItemFromCartPendiente(String itemId) async {
    if (state != null) {
      state!.items.removeWhere((item) => item.id == itemId);
      state = state!.copyWith(items: List.from(state!.items), total: _calculateTotal());
      await _updateCartPendienteInFirestore();
    }
  }

  Future<void> _updateCartPendienteInFirestore() async {
    if (state != null) {
      try {
        final docRef = db.collection('cartPendientes').doc(state!.id); // Corregido a 'cartPendientes'
        await docRef.set(state!.toFirestore());
      } catch (e) {
        print('Error al actualizar carrito pendiente en Firestore: $e');
      }
    }
  }

  double _calculateTotal() {
  return state?.items.fold(0.0, (sum, item) {

    if(sum==null){
      sum=0.0;
    }
    // Aseguramos que el precio y la cantidad no sean null, usando 0 como valor por defecto si lo son.
    final itemPrice = item.price ?? 0.0;
    final itemQuantity = item.quantity ?? 0;
    return sum + (itemPrice * itemQuantity);
  }) ?? 0.0;
}

  // Método para limpiar el carrito pendiente
  Future<void> clearCartPendiente() async {
    if (state != null) {
      state = CartPendiente(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fechaCompra: DateTime.now(),
        items: [],
        total: 0.0,
        mailPropietario: state!.mailPropietario, // Aseguramos que el email sigue presente
      );
      await _updateCartPendienteInFirestore();
    }
  }

  void increaseQuantity(String itemName) {
 
}

void decreaseQuantity(String itemName) {
  
}
}