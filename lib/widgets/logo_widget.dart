import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'lib/assets/logo.webp',
        width: 200,
        height: 200,
      ),
    );
  }
}
