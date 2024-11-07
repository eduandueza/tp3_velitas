import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/menu/menu_productos.dart';
import 'package:flutter_application_1/presentations/providers/candle_provider.dart';
import 'package:flutter_application_1/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProductsScreen extends StatelessWidget {

 const AdminProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      body: ListView.builder(
        itemCount: products.length, // VOLAR ESTO PORFAVOR, CUANDO ESTE LO FIREBASE
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () {
              
              print('Tapped on ${product.name}');
            },
          );
        },
      ),
    );
  }
}