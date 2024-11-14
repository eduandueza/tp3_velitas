import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_application_1/presentations/providers/candle_type_provider.dart';
import 'package:flutter_application_1/presentations/providers/home_screen_provider.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene la lista de velas desde el provider
    final products = ref.watch(candleProvider);
    final candleProviderNotifier = ref.read(candleProvider.notifier);

    // Obtiene los tipos de velas activos
    final candleTypes = ref.watch(candleTypeProvider);

    // Obtiene la categoría seleccionada desde el provider
    final selectedCategory = ref.watch(selectedCandleTypeHomeProvider);  // Usamos el provider adecuado para la categoría

    // Obtiene la vela seleccionada desde el provider
    final selectedCandle = ref.watch(selectedCandleItemHomeProvider);  // Usamos el provider adecuado para la vela seleccionada

    // Estado de carga
    final isLoading = products.isEmpty; // Cambiar según tu lógica

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const LogoWidget(),

            // Fila de categorías horizontales
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: candleTypes.length + 1, // Añadir un botón "Todo"
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Botón "Todo" que deselecciona cualquier categoría
                    return GestureDetector(
                      onTap: () {
                        // Desmarca cualquier categoría seleccionada
                        ref.read(selectedCandleTypeHomeProvider.notifier).state = null;
                        // Obtiene todas las velas activas
                        candleProviderNotifier.getAllCandles();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedCategory == null ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Todo',
                            style: TextStyle(
                              color: selectedCategory == null ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Categoría normal
                    final category = candleTypes[index - 1]; // Ajuste para las categorías
                    return GestureDetector(
                      onTap: () {
                        // Actualiza la categoría seleccionada
                        ref.read(selectedCandleTypeHomeProvider.notifier).state = category;

                        // Filtra las velas por la categoría seleccionada
                        candleProviderNotifier.getCandlesByCategory(category.ref);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedCategory == category ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: selectedCategory == category ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // Mostrar productos filtrados
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Llama al método que obtiene las velas activas
                  await candleProviderNotifier.getAllCandles();
                },
                child: candleProviderNotifier.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : candleProviderNotifier.noResults
                        ? const Center(child: Text('No se encontraron productos.'))
                        : products.isEmpty
                            ? const Center(child: Text('No hay velas disponibles.'))
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];

                                  // Filtrar productos por categoría si hay una categoría seleccionada
                                  if (selectedCategory != null && product.typeRef != selectedCategory.ref) {
                                    return Container(); // No mostrar este producto si no coincide con la categoría
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      // Aquí también puedes actualizar la vela seleccionada si lo necesitas
                                      ref.read(selectedCandleItemHomeProvider.notifier).state = product;

                                      // Navegar a la página de detalles del producto
                                      context.go('/productos/${product.id}');
                                    },
                                    child: Card(
                                      elevation: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            product.imageUrl ?? 'https://via.placeholder.com/100',
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              product.name,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              '\$${product.price}',
                                              style: const TextStyle(fontSize: 16, color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Ir a Login'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }
}