import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/orderCard.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final orderne = ref.watch(orderProvider);
    final userData = ref.read(userProvider);
    final email = userData.email;
    
    // Invoca la lógica para obtener las órdenes del usuario por email.
    // Esto podría hacerse solo una vez al cargar la pantalla.
    
    ref.read(orderProvider.notifier).getOrdersByEmail(email);
   
    // Obtén las órdenes del orderProvider
    final orders = ref.read(orderProvider);



    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
      ),
      body: orders.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Mientras cargan las órdenes
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order); // Suponiendo que tienes un widget para mostrar las órdenes
              },
            ),
    );
  }
}