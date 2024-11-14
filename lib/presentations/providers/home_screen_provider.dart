import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/domain/candle.dart';  // Si usas Candle en este provider
import 'package:flutter_application_1/domain/candle_type.dart';  // Para la categoría de velas

// Este provider gestiona el estado de la vela seleccionada
final selectedCandleItemHomeProvider = StateProvider<Candle?>((ref) => null);

// Este provider gestiona el estado de la categoría seleccionada
final selectedCandleTypeHomeProvider = StateProvider<CandleType?>((ref) => null);
