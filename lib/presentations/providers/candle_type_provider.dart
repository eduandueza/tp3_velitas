import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/candle_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final candleTypeProvider = StateNotifierProvider<CandleTypeProvider, List<CandleType>>(
  (ref) => CandleTypeProvider(FirebaseFirestore.instance),
);

final selectedCandleTypeProvider = StateProvider<CandleType?>((ref) => null);

class CandleTypeProvider extends StateNotifier<List<CandleType>> {
  final FirebaseFirestore db;

  CandleTypeProvider(this.db) : super([]) {
    getAllCandleTypes();
  }

  // Método para obtener todos los tipos de velas activos desde Firestore
  Future<void> getAllCandleTypes() async {
    try {
      final querySnapshot = await db.collection('candleTypes')
          .where('active', isEqualTo: true) // Solo los tipos activos
          .get();
      state = querySnapshot.docs.map((doc) {
        return CandleType.fromFirestore(doc); // Usamos `doc` directamente aquí
      }).toList();
    } catch (e) {
      print('Error obteniendo los tipos de velas: $e');
    }
  }

  // Método para agregar un nuevo tipo de vela
  Future<void> addCandleType(CandleType candleType) async {
    try {
      final docRef = db.collection('candleTypes').doc();
      await docRef.set(candleType.toFirestore());

      // Agregar el nuevo tipo al estado local
      state = [...state, candleType.copyWith(id: docRef.id, ref: docRef)];
    } catch (e) {
      print('Error agregando tipo de vela: $e');
    }
  }

  // Método para actualizar un tipo de vela
  Future<void> updateCandleType(CandleType updatedCandleType) async {
    try {
      final docRef = db.collection('candleTypes').doc(updatedCandleType.id);
      await docRef.update(updatedCandleType.toFirestore());

      // Actualiza el estado local
      state = state.map((candleType) {
        if (candleType.id == updatedCandleType.id) {
          return updatedCandleType.copyWith(ref: docRef); // Actualizamos la referencia
        }
        return candleType;
      }).toList();
    } catch (e) {
      print('Error actualizando el tipo de vela: $e');
    }
  }

  // Método para eliminar un tipo de vela (borrado lógico, pone active en false)
Future<void> deactivateCandleType(String id) async {
  try {
    final docRef = db.collection('candleTypes').doc(id);
    await docRef.update({'active': false}); // Realiza el borrado lógico

    // Actualiza el estado local, marcando como inactivo el tipo de vela
    state = state.map((candleType) {
      if (candleType.id == id) {
        return candleType.copyWith(active: false); // Marca como inactivo
      }
      return candleType;
    }).toList();

    // Llama al método getAllCandleTypes para obtener todos los tipos de vela y actualizar el estado local
    await getAllCandleTypes(); // Actualiza la lista de tipos de vela desde Firestore

  } catch (e) {
    print('Error desactivando el tipo de vela: $e');
  }
}

}
