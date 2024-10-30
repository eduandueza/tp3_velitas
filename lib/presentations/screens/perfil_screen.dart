import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../widgets/SectionTitle.dart';
import '../../widgets/profileHeader.dart';
import '../../widgets/profileOptions.dart';
import '../providers/user_provider.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final userData = ref.watch(userProvider);

    return Scaffold(
      //backgroundColor: const Color(0xFFF7EAF0), 
      appBar: AppBar(
       
      ),
      body: Column(
        children: [
          ProfileHeader(
            username: userData.name, 
            email: userData.email,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                const SectionTitle(title: "Información"),
                ProfileOption(
                  icon: Icons.location_on,
                  title: "Mis Direcciones",
                  subtitle: "Direcciones para recibir tu pedido",
                  onTap: () => context.push('/perfil/direcciones', extra: userData.addresses),
                ),
                ProfileOption(
                  icon: Icons.shopping_cart,
                  title: "Mis Pedidos",
                  subtitle: "Ver historial de pedidos recientes",
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.favorite,
                  title: "Mis Favoritos",
                  subtitle: "Ver productos que has marcado como favoritos",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MainMenu(),
    );
  }
}
