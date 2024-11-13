import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

class UserCard extends ConsumerWidget {
  final UserData user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(userProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.white, 
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Chip(
                    label: Text(
                      user.rol, 
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: user.rol == 'Admin'
                        ? Colors.redAccent
                        : Colors.blueAccent, 
                  ),
                ],
              ),
            ),
            
            IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () async {
                
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Eliminar usuario"),
                    content: const Text("¿Estás seguro de que deseas eliminar a este usuario?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Eliminar"),
                      ),
                    ],
                  ),
                );

                
                if (confirm == true) {
                  try {
                    await userNotifier.removeUserByEmail(user.email); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Usuario ${user.name} eliminado')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al eliminar el usuario')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}




