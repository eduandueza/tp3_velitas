import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/modelo_carrito.dart';
import 'package:flutter_application_1/core/router/menu/menu_productos.dart';
import 'package:flutter_application_1/presentations/providers/carrito_provider.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_application_1/widgets/product_image_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

class ProductoDetailScreen extends ConsumerWidget { 
  final String productId;

  const ProductoDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final product = products.firstWhere((product) => product.id == productId);

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
              LogoWidget(),
              const SizedBox(height: 20),
              Center(
                child: ProductImageWidget(imageUrl: product.imageUrl),
              ),
              const SizedBox(height: 20),
              _buildProductInfo(context, product),
              const SizedBox(height: 20),
              _buildAddToCartButton(context, product, ref), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainMenu(),
    );
  }

  Widget _buildProductInfo(BuildContext context, Product product) {
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

  Widget _buildAddToCartButton(BuildContext context, Product product, WidgetRef ref) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          final cartNotifier = ref.read(cartProvider.notifier); 
          cartNotifier.addItem(CartItem(name: product.name, price: product.price));
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
  }}
