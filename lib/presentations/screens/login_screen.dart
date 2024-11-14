/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/auth_provider.dart';
import 'package:flutter_application_1/presentations/providers/user_provider.dart';
import 'package:flutter_application_1/presentations/screens/create_account_screen.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LogoWidget(),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: "Correo",
              icon: Icons.email_outlined,
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: "Contraseña",
              icon: Icons.lock_outline,
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Acceder",
              onPressed: () {
                // Cerrar el teclado al presionar el botón
                FocusScope.of(context).unfocus();
                

                String email = emailController.text;
                String password = passwordController.text;

                ref.read(authProvider.notifier).login(email, password);
                /*final authUser = ref.watch(authProvider);
                final uid= authUser?.uid;
                ref.read(userProvider.loadUserData(uid));*/

                //LLAMAR A EL METODO LOGIN DEL AUTH
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
                );
              },
              child: const Text("Crear cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/auth_provider.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Asegúrate de importar GoRouter

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LogoWidget(),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: "Correo",
              icon: Icons.email_outlined,
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: "Contraseña",
              icon: Icons.lock_outline,
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Acceder",
              onPressed: () async {
                FocusScope.of(context).unfocus();

                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Advertencia"),
                      content: Text(email.isEmpty
                          ? "Por favor, ingrese un correo electrónico."
                          : "Por favor, ingrese una contraseña."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Aceptar"),
                        ),
                      ],
                    ),
                  );
                } /*else {
                  try {
                    // Intentar iniciar sesión
                    await authNotifier.login(email, password);
                    print("Inicio de sesión exitoso. Redirigiendo a Home...");
                    // Si el login es exitoso, redirigir a la pantalla de inicio
                    
                  } catch (e) {
                    print("Error de inicio de sesión: $e");
                    
                  }

                  if (ref.read(userProvider.notifier).logueado(email)){
                    context.go('/');
                  }
                  context.go('/');

                }
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                context.push('/crear'); 
              },
              child: const Text("Crear cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}*/
else {
                  try {
                    // Intentar iniciar sesión
                    await authNotifier.login(email, password);
                    print("Inicio de sesión exitoso. Redirigiendo a Home...");

                    // Usamos Future.microtask para asegurar que el redireccionamiento ocurre en el siguiente ciclo de eventos
                    Future.microtask(() {
                      context.go('/'); // Redirigir a la pantalla de inicio
                    });

                  } catch (e) {
                    print("Error de inicio de sesión: $e");
                  }
                }
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                context.push('/crear');
              },
              child: const Text("Crear cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/providers/auth_provider.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    final authState = ref.watch(authProvider); // Estado de autenticación actual
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Redirigir a la pantalla de inicio si el usuario está autenticado
    if (authState != null) {
      Future.microtask(() => context.go('/')); 
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LogoWidget(),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: "Correo",
              icon: Icons.email_outlined,
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: "Contraseña",
              icon: Icons.lock_outline,
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Acceder",
              onPressed: () async {
                FocusScope.of(context).unfocus();

                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Advertencia"),
                      content: Text(email.isEmpty
                          ? "Por favor, ingrese un correo electrónico."
                          : "Por favor, ingrese una contraseña."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Aceptar"),
                        ),
                      ],
                    ),
                  );
                } else {
                  try {
                    // Intentar iniciar sesión
                    await authNotifier.login(email, password);
                    print("Inicio de sesión exitoso. Redirigiendo a Home...");
                  } catch (e) {
                    print("Error de inicio de sesión: $e");
                  }
                }
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                context.push('/crear');
              },
              child: const Text("Crear cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
