import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class CategoryProductsScreen extends ConsumerWidget {
  final String candleTypeId;

  const CategoryProductsScreen({Key? key, required this.candleTypeId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene las velas filtradas por tipo de vela (candleTypeId)
    final products = ref.watch(candleProvider).where((candle) => candle.candleTypeId == candleTypeId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Velas de la Categoría'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              context.go('/productos/${product.id}');
            },
            child: Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Image.asset(
                    '${product.imageUrl}',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),*/
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
    );
  }
}
