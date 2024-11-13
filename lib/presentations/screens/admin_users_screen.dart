import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart'; // Asegúrate de importar el modelo
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_application_1/widgets/UserCard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 // Asegúrate de importar la Card de usuario que creaste

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart'; // Asegúrate de importar el modelo
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/core/router/items/model_userData.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersNotifier = ref.read(userProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
      ),
      body: FutureBuilder<List<UserData>>(
        
        future: usersNotifier.getAllUsers(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay usuarios disponibles"));
          }

          
          final validUsers = snapshot.data!.where((user) {
            
            return user.name.isNotEmpty && user.email.isNotEmpty && user.rol.isNotEmpty;
          }).toList();

          
          if (validUsers.isEmpty) {
            return const Center(child: Text("No hay usuarios válidos"));
          }

          return ListView.builder(
            itemCount: validUsers.length,
            itemBuilder: (context, index) {
              final user = validUsers[index];
              return UserCard(user: user); 
            },
          );
        },
      ),
    );
  }
}

