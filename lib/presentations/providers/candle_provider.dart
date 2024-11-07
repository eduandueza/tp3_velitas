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
      // Subir imagen a Firebase Storage
      // Comentado para evitar errores hasta que configures Storage correctamente
      /*
      final imageRef = storage.ref().child('images/${docRef.id}');
      final uploadTask = imageRef.putFile(File(imagePath));
      final imageUrl = await (await uploadTask).ref.getDownloadURL();
      */

      final imageUrl = 'dummy_image_url'; // URL de imagen temporal para la demo

      // Crear un nuevo Candle con la URL de la imagen
      final newCandle = candle.copyWith(id: docRef.id, imageUrl: imageUrl);

      await docRef.set(newCandle.toFirestore());
      state = [...state, newCandle]; // Agrega la vela al estado
    } catch (e) {
      print(e);
      print("ERROR CONEXION FIREBASE");
    }
  }

 // Método para obtener una vela específica por su ID
  Future<Candle?> getCandleById(String id) async {
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
  }

  // Método para obtener todas las velas de Firestore
  Future<void> getAllCandles() async {
    try {
      final querySnapshot = await db.collection('products').get();
      state = querySnapshot.docs.map((doc) {
        return Candle.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print(e);
    }
  }
}
