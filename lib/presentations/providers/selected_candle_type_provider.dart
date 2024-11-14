import 'package:flutter_application_1/domain/candle_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// El provider para almacenar el tipo de vela seleccionado por el usuario.
final selectedCandleTypeProvider = StateProvider<CandleType?>((ref) => null);
