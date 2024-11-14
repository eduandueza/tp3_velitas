import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart'; // Importa Firebase Storage
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/candle.dart';

final candleProvider = StateNotifierProvider<CandleProvider, List<Candle>>(
  (ref) => CandleProvider(FirebaseFirestore.instance),
);

class CandleProvider extends StateNotifier<List<Candle>> {
  final FirebaseFirestore db;
  bool isLoading = false;
  bool noResults = false;

  CandleProvider(this.db) : super([]) {
    getAllCandles();
  }

  // Método para agregar una vela con imagen
  Future<void> addCandleWithImage(Candle candle, String imagePath) async {
    final docRef = db.collection('products').doc();
    try {
      final imageUrl = 'dummy_image_url';  // Simula la URL de la imagen

      // Crear un nuevo Candle con la URL de la imagen
      final newCandle = candle.copyWith(id: docRef.id, imageUrl: imageUrl);

      await docRef.set(newCandle.toFirestore());
      state = [...state, newCandle]; // Agrega la vela al estado
    } catch (e) {
      print(e);
      print("ERROR CONEXION FIREBASE");
    }
  }

  // Método para actualizar el stock de una vela
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
  Candle? getCandleById(String id) {
    try {
      return state.firstWhere((candle) => candle.id == id);
    } catch (e) {
      return null; // Si no se encuentra, devuelve null
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

  // Método para desactivar una vela (borrado lógico)
  Future<void> deactivateCandle(String id) async {
    try {
      final docRef = db.collection('products').doc(id);
      await docRef.update({'active': false});  // Desactiva la vela

      // Recargar todas las velas activas después de la desactivación
      await getAllCandles();  // Llamada a getAllCandles para recargar la lista
    } catch (e) {
      print('Error desactivando la vela: $e');
    }
  }

  // Método para obtener todas las velas activas de Firestore
  Future<void> getAllCandles() async {
    try {
      isLoading = true;
      noResults = false;
      state = [];  // Limpiar el estado antes de la consulta

      final querySnapshot = await db.collection('products')
          .where('active', isEqualTo: true)  // Filtra solo las velas activas
          .get();

      if (querySnapshot.docs.isEmpty) {
        noResults = true;  // Si no hay resultados, establecer noResults como true
      }

      // Actualiza el estado con las velas activas
      state = querySnapshot.docs.map((doc) {
        return Candle.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error obteniendo velas activas: $e');
      noResults = true;
      state = [];
    } finally {
      isLoading = false;
    }
  }

  // Método para obtener velas filtradas por categoría (typeRef)
  Future<void> getCandlesByCategory(DocumentReference? categoryRef) async {
    if (categoryRef == null) {
      // Si categoryRef es null, simplemente no hacemos nada o podemos mostrar todas las velas
      await getAllCandles();
      return;
    }

    try {
      isLoading = true;
      noResults = false;
      state = [];  // Limpiar el estado antes de la consulta

      final querySnapshot = await db.collection('products')
          .where('active', isEqualTo: true)
          .where('type_ref', isEqualTo: categoryRef)  // Filtra por categoría
          .get();

      if (querySnapshot.docs.isEmpty) {
        noResults = true;  // Si no hay resultados, establecer noResults como true
      }

      // Actualiza el estado con las velas filtradas por categoría
      state = querySnapshot.docs.map((doc) {
        return Candle.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error obteniendo velas por categoría: $e');
      noResults = true;
      state = [];
    } finally {
      isLoading = false;
    }
  }

Future<void> updateCandleStockAfterPurchase(String candleName, int quantity) async {
  try {
    
      Candle? candle=null;

    try{
     candle = state.firstWhere((c) => c.name == candleName);
    }catch(e){}
    

    if (candle != null) {
      final newStock = candle.stock - quantity;

      
      if (newStock < 0) {
        throw Exception('Stock insuficiente para ${candle.name}');
      }

      
      final docRef = db.collection('products').doc(candle.id);
      await docRef.update({'stock': newStock});

      
      state = state.map((c) {

        if (c.id == candle?.id) {
          return c.copyWith(stock: newStock);
        }
        return c;
      }).toList();

    } else {
      throw Exception('Vela no encontrada: $candleName');
    }
  } catch (e) {
    print("Error actualizando stock: $e");
}
}


}
