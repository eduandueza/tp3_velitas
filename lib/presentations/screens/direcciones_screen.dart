import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/deleteAddressButton.dart';
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
               DeleteAddressButton(address: addresses[index], ref: ref), 
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
      
      TextEditingController calleController = TextEditingController();
      TextEditingController alturaController = TextEditingController();
      TextEditingController provinciaController = TextEditingController();
      TextEditingController paisController = TextEditingController();
      
      return AlertDialog(
        title: const Text('Agregar Dirección'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: calleController,
                decoration: const InputDecoration(labelText: 'Calle'),
              ),
              TextField(
                controller: alturaController,
                decoration: const InputDecoration(labelText: 'Altura'),
              ),
              TextField(
                controller: provinciaController,
                decoration: const InputDecoration(labelText: 'Provincia'),
              ),
              TextField(
                controller: paisController,
                decoration: const InputDecoration(labelText: 'Pais'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              
              final direccionCompleta = '${calleController.text}, ${alturaController.text}, ${provinciaController.text}, ${paisController.text}';
              if (calleController.text.isNotEmpty && alturaController.text.isNotEmpty && provinciaController.text.isNotEmpty && paisController.text.isNotEmpty) {
                ref.read(userProvider.notifier).addAddress(direccionCompleta);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, completa todos los campos.')),
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
}



  }
