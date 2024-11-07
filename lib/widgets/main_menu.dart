import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/carrito_provider.dart';
import 'package:flutter_application_1/presentations/providers/menu_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainMenu extends ConsumerWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(menuProvider).selectedIndex;
    final totalItems = ref.watch(carritoProvider).fold(0, (sum, item) => sum + item.quantity);

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
      destinations: <Widget>[
        const NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Stack(
            children: [
              const Icon(Icons.shopping_cart),
              if (totalItems > 0)
                Positioned(
                  left: 10,
                  top: 2.5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 212, 84, 195),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      totalItems.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          label: 'Carrito',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
