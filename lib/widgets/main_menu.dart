import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/menu_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(menuProvider).selectedIndex;

    return NavigationBar(
      onDestinationSelected: (int index) {
        ref.read(menuProvider.notifier).changeMenuIndex(index);

        if (index == 0) {
          context.go('/');
        } else if (index == 1) {
          context.go('/carrito');
        } else if (index == 2) {
          context.go('/perfil');
        }
      },
      indicatorColor: const Color.fromARGB(255, 117, 165, 127),
      selectedIndex: currentIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart),
          label: 'Carrito',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
