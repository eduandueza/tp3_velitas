import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/main_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(), 
        title: const Text('Perfil'),
      ),
      body: const Center(
        child: Text('Contenido del Perfil'),
      ),
      bottomNavigationBar: MainMenu(),
    );
  }
}
