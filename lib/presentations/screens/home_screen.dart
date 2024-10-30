import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/menu/menu_productos.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Asegúrate de importar candleTypeProvider y CandleType
import 'package:flutter_application_1/presentations/providers/candle_type_provider.dart';
import 'package:flutter_application_1/domain/candle_type.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el provider de categorías de velas
    final candleTypesAsync = ref.watch(candleTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LogoWidget(),
            Expanded(
              child: candleTypesAsync.when(
                data: (candleTypes) => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: candleTypes.length,
                  itemBuilder: (context, index) {
                    final candleType = candleTypes[index];
                    return GestureDetector(
                      onTap: () {
                        // Navega a la pantalla de productos filtrados por tipo de vela
                        context.go('/productos/${candleType.id}');
                      },
                      child: Card(
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Aquí puedes agregar una imagen genérica o personalizada para cada tipo de vela
                            Image.asset(
                              'assets/aroo1.webp',
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                candleType.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                candleType.size,
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainMenu(),
    );
  }
}
