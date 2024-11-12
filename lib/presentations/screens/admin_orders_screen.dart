import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_application_1/presentations/providers/order_provider.dart';
import 'package:flutter_application_1/widgets/orderCard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreenAdmin extends ConsumerWidget {
  const OrdersScreenAdmin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final ordersNotifier = ref.read(orderProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
      ),
      body: FutureBuilder<List<UserOrder>>(
        
        future: ordersNotifier.getAllOrders(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay órdenes disponibles"));
          }

          
          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(order: order); 
            },
          );
        },
      ),
    );
  }
}