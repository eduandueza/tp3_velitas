import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/order_provider.dart';
import 'package:flutter_application_1/widgets/orderCard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreenAdmin extends ConsumerWidget {
  const OrdersScreenAdmin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
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