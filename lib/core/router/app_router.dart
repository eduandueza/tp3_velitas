import 'package:flutter_application_1/presentations/screens/carrito_screen.dart';
import 'package:flutter_application_1/presentations/screens/home_screen.dart';
import 'package:flutter_application_1/presentations/screens/login_screen.dart';
import 'package:flutter_application_1/presentations/screens/producto_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: ('/login'),
      builder: (context, state) => const LoginScreen(),
    ),
        GoRoute(
      path: ('/'),
      builder: (context, state) => const HomeScreen(),
    ),
        GoRoute(
      path: ('/productos'),
      builder: (context, state) => const ProductoScreen(),
    ),
        GoRoute(
      path: ('/carrito'),
      builder: (context, state) => const CarritoScreen(),
    ),
  ],
);