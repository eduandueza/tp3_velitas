import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (GoRouter.of(context).canPop()) {
          context.pop();
        } else {
          context.go('/'); 
        }
      },
    );
  }
}
