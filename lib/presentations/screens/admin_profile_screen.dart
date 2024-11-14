import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/auth_provider.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_application_1/widgets/profileOptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userData = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Administrador"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            ProfileOption(
              icon: Icons.shopping_cart,
              title: "Pedidos",
              subtitle: "Gestionar los pedidos",
              onTap: () => context.push('/admin/orders'),
            ),
            const SizedBox(height: 16),
            ProfileOption(
              icon: Icons.production_quantity_limits,
              title: "Productos",
              subtitle: "Gestionar los productos",
              onTap: () => context.push('/admin/products'),
            ),
            const SizedBox(height: 16),
            ProfileOption(
              icon: Icons.people,
              title: "Usuarios",
              subtitle: "Gestionar los usuarios",
              onTap: () => context.push('/admin/users'),
            ),
            const SizedBox(height: 16),
            ProfileOption(
              icon: Icons.category,
              title: "Categorías",
              subtitle: "Gestionar las categorías",
              onTap: () => context.push('/admin/categories'),
            ),ProfileOption(
                  icon: Icons.logout,
                  title: "Cerrar sesión",
                  subtitle: "",
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    context.push('/login');
                  }
                ),
          ],
        ),
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }
}