import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/candle_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final candleTypeProvider = FutureProvider<List<CandleType>>((ref) async {
  final db = FirebaseFirestore.instance;
  final querySnapshot = await db.collection('candleTypes').get();
  return querySnapshot.docs
      .map((doc) => CandleType.fromFirestore(doc.data(), doc.id))
      .toList();
});
