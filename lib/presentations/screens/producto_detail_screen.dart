import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

import 'package:flutter_application_1/domain/candle.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_application_1/presentations/providers/cartItem_provider.dart';
import 'package:flutter_application_1/presentations/providers/cartPendiente_provider.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_application_1/widgets/product_image_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/modelo_cartItem.dart';

import 'package:flutter_application_1/domain/candle.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_application_1/presentations/providers/cartItem_provider.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductoDetailScreen extends ConsumerWidget { 
  final String productId;

  const ProductoDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final product = ref.watch(candleProvider.notifier).getCandleById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Producto no encontrado")),
        body: Center(child: Text("El producto no existe.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoWidget(),
              const SizedBox(height: 20),
              Center(
                child: Image.network(
                  product.imageUrl ?? 'https://via.placeholder.com/100',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              _buildProductInfo(context, product),
              const SizedBox(height: 20),
              _buildAddToCartButton(context, product, ref), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }

  Widget _buildProductInfo(BuildContext context, Candle product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          'Descripción:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          product.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                height: 1,
              ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context, Candle product, WidgetRef ref) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final cartItemProvider = ref.read(cartPendienteProvider.notifier);
          
           cartItemProvider.addItemToCartPendiente(
            CartItem(
              id: DateTime.now().toString(), // id temporal, puede ser cambiado si necesitas otra lógica
              name: product.name,
              price: product.price,
              quantity: 1, 
            ),
          );

          // Mostrar mensaje de snack bar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} agregado al carrito!')),
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Agregar al carrito'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}

