import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/cartCard.dart';
import '../providers/cart_provider.dart';

class CartsScreen extends ConsumerWidget {
  const CartsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carts = ref.watch(carritosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
      ),
      body: ListView.builder(
        itemCount: carts.length,
        itemBuilder: (context, index) {
          final cart = carts[index];
          return CartCard(cart: cart); 
        },
      ),
    );
  }
}