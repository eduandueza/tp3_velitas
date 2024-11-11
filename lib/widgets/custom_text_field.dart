import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;

  CustomTextField({
    super.key,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      enableInteractiveSelection: false, 
      showCursor: false,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
      ),
    );
  }
}
