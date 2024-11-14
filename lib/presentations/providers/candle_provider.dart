import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart'; // Importa Firebase Storage
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/candle.dart';

final candleProvider = StateNotifierProvider<CandleProvider, List<Candle>>(
  (ref) => CandleProvider(FirebaseFirestore.instance),
);

class CandleProvider extends StateNotifier<List<Candle>> {
  final FirebaseFirestore db;
 // final FirebaseStorage storage; // Referencia a Firebase Storage

  CandleProvider(this.db) : super([]) {
    getAllCandles();
  }

  // Método para agregar una vela con imagen
  Future<void> addCandleWithImage(Candle candle, String imagePath) async {
    final docRef = db.collection('products').doc();
    try {
      final imageUrl = 'dummy_image_url'; 

      // Crear un nuevo Candle con la URL de la imagen
      final newCandle = candle.copyWith(id: docRef.id, imageUrl: imageUrl);

      await docRef.set(newCandle.toFirestore());
      state = [...state, newCandle]; // Agrega la vela al estado
    } catch (e) {
      print(e);
      print("ERROR CONEXION FIREBASE");
    }
  }

 // Modificación: Método para actualizar el stock
  Future<void> updateCandleStock(String id, int newStock) async {
    try {
      final docRef = db.collection('products').doc(id);
      await docRef.update({'stock': newStock}); // Actualiza el stock en Firebase

      // Actualiza el estado local de la vela en la lista
      state = state.map((candle) {
        if (candle.id == id) {
          return candle.copyWith(stock: newStock); // Actualiza el stock localmente
        }
        return candle;
      }).toList();
    } catch (e) {
      print('Error actualizando el stock: $e');
    }
  }



 // Método para obtener una vela específica por su ID
  /*Future<Candle?> getCandleById(String id) async {
    try {
      final docSnapshot = await db.collection('products').doc(id).get();
      if (docSnapshot.exists) {
        return Candle.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      }
      return null; // Si no existe la vela
    } catch (e) {
      print("Error obteniendo vela por ID: $e");
      return null;
    }
  }*/

  Candle? getCandleById(String id) {
  // Devuelve el Candle si existe en el state, o null si no se encuentra
    try {
    // Intenta encontrar el Candle con el ID proporcionado
    return state.firstWhere((candle) => candle.id == id);
  } catch (e) {
    // Si no se encuentra, devuelve null
    return null;
  }
}


 // Método para actualizar un producto
  Future<void> updateCandle(Candle updatedCandle) async {
    try {
      final docRef = db.collection('products').doc(updatedCandle.id);
      
      // Actualiza el documento en Firebase
      await docRef.update(updatedCandle.toFirestore());

      // Actualiza el estado local de la lista de productos
      state = state.map((candle) {
        if (candle.id == updatedCandle.id) {
          return updatedCandle; // Reemplaza el producto con los nuevos datos
        }
        return candle;
      }).toList();
    } catch (e) {
      print('Error actualizando el producto: $e');
    }
  }




/*
 // Método para marcar una vela como inactiva (borrado lógico)
  Future<void> deactivateCandle(String id) async {
    try {
      final docRef = db.collection('products').doc(id);

      // Actualiza el campo 'active' a false para hacer el borrado lógico
      await docRef.update({'active': false});

      // Actualiza el estado local de la vela
      state = state.map((candle) {
        if (candle.id == id) {
          return candle.copyWith(active: false); // Marca la vela como inactiva
        }
        return candle;
      }).toList();
    } catch (e) {
      print('Error desactivando la vela: $e');
    }
  }
  */
  Future<void> deactivateCandle(String id) async {
    try {
      final docRef = db.collection('products').doc(id);

    // Actualiza el campo 'active' a false para hacer el borrado lógico
      await docRef.update({'active': false});

    // Recargar todas las velas activas después de la desactivación
      await getAllCandles(); // Llamada a getAllCandles para recargar la lista

    } catch (e) {
     print('Error desactivando la vela: $e');
   }
  }


   // Método para obtener todas las velas de Firestore que estén activas
  Future<void> getAllCandles() async {
    try {
      final querySnapshot = await db.collection('products')
          .where('active', isEqualTo: true)  // Filtrar solo las velas activas
          .get();

      state = querySnapshot.docs.map((doc) {
        return Candle.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error obteniendo velas activas: $e');
    }
  }




  
}
