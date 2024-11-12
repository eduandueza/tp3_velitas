import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_order.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/orderCard.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.read(userProvider);
    final email = userData.email;
    
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
      ),
      body: FutureBuilder<List<UserOrder>>(
        future: ref.read(orderProvider.notifier).getOrdersByEmail(email), 
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order); 
              },
            );
          }

          // Si no hay datos (lista vacía)
          return const Center(child: Text("No hay órdenes disponibles"));
        },
      ),
    );
  }
}