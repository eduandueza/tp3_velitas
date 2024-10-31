import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/orderCard.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
      ),
      
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order  = orders[index];
          return OrderCard(order: order); 
        },
      ),
    );
  }
}