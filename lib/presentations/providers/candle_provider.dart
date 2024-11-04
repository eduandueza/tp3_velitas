import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/candle.dart';

final candleProvider = StateNotifierProvider<CandleProvider, List<Candle>>(
  (ref) => CandleProvider(FirebaseFirestore.instance),
);

class CandleProvider extends StateNotifier<List<Candle>> {
  final FirebaseFirestore db;

  CandleProvider(this.db) : super([]);

  Future<void> addCandle(Candle candle) async {
    final docRef = db.collection('products').doc();
    try {
      await docRef.set(candle.toFirestore());
      // Agrega el nuevo objeto Candle a la lista de estado
      state = [...state, candle.copyWith(id: docRef.id)];
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllCandles() async {
    // Limpia el estado antes de obtener nuevos datos
    state = [];
    final querySnapshot = await db.collection('products').get();
    state = querySnapshot.docs.map((doc) {
      return Candle.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}
