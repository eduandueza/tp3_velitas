import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_application_1/presentations/screens/admin_profile_screen.dart';
import 'package:flutter_application_1/presentations/screens/perfil_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreenSelector extends ConsumerWidget {
  const ProfileScreenSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);

    if(user.rol == 'ADMIN'){
      return const AdminProfileScreen();
    }else {
      return const PerfilScreen();
    }
    
  }
}