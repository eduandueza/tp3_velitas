import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';

 

class DireccionesScreen extends ConsumerWidget { 
  const DireccionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);
    final addresses = userData.addresses; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Direcciones'),
      ),
      body: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(addresses[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    
                    _editarDireccion(context, ref, addresses[index]);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                   
                    ref.read(userProvider.notifier).removeAddress(addresses[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          _agregarDireccion(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editarDireccion(BuildContext context, WidgetRef ref, String direccion) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController controller = TextEditingController(text: direccion);
      return AlertDialog(
        title: const Text('Editar Dirección'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nueva Dirección'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final nuevaDireccion = controller.text;
              
              ref.read(userProvider.notifier).editAddress(direccion, nuevaDireccion);
              context.pop(); 
            },
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

  void _agregarDireccion(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController controller = TextEditingController();
      return AlertDialog(
        title: const Text('Agregar Dirección'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nueva Dirección'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final nuevaDireccion = controller.text;
              if (nuevaDireccion.isNotEmpty) {
                
                ref.read(userProvider.notifier).addAddress(nuevaDireccion);
                context.pop(); 
              } else {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, ingresa una dirección.')),
                );
              }
            },
            child: const Text('Agregar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}}
