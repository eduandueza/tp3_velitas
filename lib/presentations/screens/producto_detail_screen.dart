import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/menu/menu_productos.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';

class ProductoDetailScreen extends StatelessWidget {
  final String productId;

  const ProductoDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = products.firstWhere((product) => product.id == productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Column(
        children: [
          LogoWidget(),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: MainMenu(),
    );
  }
}
