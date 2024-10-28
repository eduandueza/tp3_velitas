import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de productos de ejemplo (puedes reemplazar esto con tus datos reales)
    final cartItems = [
      {
        'name': 'Producto 1',
        'price': 29.99,
        'quantity': 1,
      },
      {
        'name': 'Producto 2',
        'price': 49.99,
        'quantity': 2,
      },

    ];

    double total = cartItems.fold(0, (sum, item) {
      return sum + (item['price'] as double) * (item['quantity'] as int);
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: const Text('Carrito'),
      ),
      body: Column(
        children: [
          LogoWidget(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item['name'] as String), // Asegúrate de convertir a String
                  subtitle: Text('Precio: \$${(item['price'] as double).toStringAsFixed(2)} x ${item['quantity'] as int}'), // Asegúrate de convertir a String
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      // Lógica para eliminar el producto del carrito
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para proceder a la compra
            },
            child: const Text('Proceder a la Compra'),
          ),
        ],
      ),
      bottomNavigationBar: MainMenu(),
    );
  }
}
