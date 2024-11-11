import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/auth_provider.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


  class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final authNotifier = ref.watch(authProvider.notifier);
    final userNotifier = ref.watch(userProvider.notifier);

    // variables para los datos del formulario
    final TextEditingController nameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: const Text('Crear Cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LogoWidget(),
            const SizedBox(height: 20),
            const Text(
              "Crear Cuenta",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: CustomTextField(controller: nameController, labelText: "Nombre", icon: Icons.person_outline)),
                const SizedBox(width: 8),
                Expanded(child: CustomTextField(controller: lastNameController, labelText: "Apellido", icon: Icons.person_outline)),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: emailController, labelText: "Correo", icon: Icons.email_outlined),
            const SizedBox(height: 16),
            CustomTextField(controller: passwordController, labelText: "Contraseña", icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 20),
            CustomButton(
              text: "Crear cuenta",
              onPressed: () async {
                
                FocusScope.of(context).unfocus();

                
                final email = emailController.text;
                final password = passwordController.text;
                final name = nameController.text;
                final lastName = lastNameController.text;

                // COMO TE ODIO FLUTTER

                try {
                  
                  await authNotifier.register(email, password);

                }catch (s){
                   print ("error a crear el registro en la bd perooo: $s");
                }  
 
                try{
                  // Una vez que el registro es exitoso se guarda una instancia en el state de userProvider
                  final userId = authNotifier.getUid();
                  if (userId != null) {
                    
                    await userNotifier.createUserInFirestore(
                      userId: userId,
                      name: name,
                      email: email,
                      photoUrl: '', 
                    );

                    print ("SE CREO EL USUARIO Y SE GUARDO EN LA BD");
                    print ("SE CREO EL USUARIO Y SE GUARDO EN LA BD");
                    print ("SE CREO EL USUARIO Y SE GUARDO EN LA BD");
                    print ("SE CREO EL USUARIO Y SE GUARDO EN LA BD");
                    print ("SE CREO EL USUARIO Y SE GUARDO EN LA BD");
                    print ("SE CREO EL USUARIO Y SE GUARDO EN LA BD");
                    print ("SE CREO EL USUARIO Y SE GUARDO EN LA BD");

                    
                    context.push('/login');
                  }
                } catch (e) {
                  
                  print("Error al crear la cuenta: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


