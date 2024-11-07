import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/back_button.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/logo_widget.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              "Let's create your account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: CustomTextField(labelText: "Nombre", icon: Icons.person_outline)),
                const SizedBox(width: 8),
                Expanded(child: CustomTextField(labelText: "Apellido", icon: Icons.person_outline)),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(labelText: "Usuario", icon: Icons.person),
            const SizedBox(height: 16),
            CustomTextField(labelText: "Correo", icon: Icons.email_outlined),
            const SizedBox(height: 16),
            CustomTextField(labelText: "Contraseña", icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 20),
            CustomButton(
              text: "Crear cuenta",
              onPressed: () {
                // Cerrar el teclado al presionar el botón
                FocusScope.of(context).unfocus();

                // Aquí puedes agregar la lógica para crear la cuenta
              },
            ),
          ],
        ),
      ),
    );
  }
}
