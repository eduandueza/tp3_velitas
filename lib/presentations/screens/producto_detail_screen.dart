import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/menu/menu_productos.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_application_1/widgets/product_image_widget.dart';

class ProductoDetailScreen extends StatelessWidget {
  final String productId;

  const ProductoDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                child: ProductImageWidget(
                  imageUrl: product.imageUrl),
              ),
              const SizedBox(height: 20),
              _buildProductInfo(context, product),
              const SizedBox(height: 20),

              // Botón de agregar al carrito
              _buildAddToCartButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  MainMenu(),
    );
  }

  // info del producto
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
                height: 1.5,
              ),
        ),
      ],
    );
  }

  // boton de agregar al carrito
  Widget _buildAddToCartButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
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
