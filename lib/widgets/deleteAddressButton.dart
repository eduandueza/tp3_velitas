import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentations/providers/user_provider.dart';


class DeleteAddressButton extends StatelessWidget {
  final String address;
  final WidgetRef ref;

  const DeleteAddressButton({
    Key? key,
    required this.address,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
       
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar eliminacion'),
              content: const Text('¿Estas seguro de que deseas eliminar esta direccion?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(userProvider.notifier).removeAddress(address);
                    Navigator.of(context).pop(); 
                  },
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}