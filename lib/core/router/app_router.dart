import 'package:flutter_application_1/presentations/screens/admin_candleType_screen.dart';
import 'package:flutter_application_1/presentations/screens/admin_orders_screen.dart';
import 'package:flutter_application_1/presentations/screens/admin_products_screen.dart';
import 'package:flutter_application_1/presentations/screens/admin_users_screen.dart';
import 'package:flutter_application_1/presentations/screens/approved_screen.dart';
import 'package:flutter_application_1/presentations/screens/carrito_screen.dart';
import 'package:flutter_application_1/presentations/screens/create_account_screen.dart';
import 'package:flutter_application_1/presentations/screens/disapproved_screen.dart';
import 'package:flutter_application_1/presentations/screens/home_screen.dart';
import 'package:flutter_application_1/presentations/screens/login_screen.dart';
import 'package:flutter_application_1/presentations/screens/orders_screen.dart';
import 'package:flutter_application_1/presentations/screens/perfil_screen.dart';
import 'package:flutter_application_1/presentations/screens/producto_detail_screen.dart';
import 'package:flutter_application_1/presentations/screens/profile_screen_selector.dart';
import 'package:go_router/go_router.dart';

import '../../presentations/screens/direcciones_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), 
    ),
    GoRoute(
      path: '/productos/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductoDetailScreen(productId: productId); 
      },
    ),
    GoRoute(
      path: '/carrito',
      builder: (context, state) => const CarritoScreen(),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const ProfileScreenSelector(),
    ),
    GoRoute(
      path: '/perfil/direcciones',
      builder: (context, state) => const DireccionesScreen(),
      ),
    GoRoute(
      path: '/perfil/pedidos',
      builder: (context, state) => const OrdersScreen(),
      ),
    GoRoute(
      path: '/admin/orders',
      builder: (context, state) => const OrdersScreenAdmin(),
      ),
    GoRoute(
      path: '/admin/products',
      builder: (context, state) => const AdminProductsScreen(),
      ),
       GoRoute(
      path: '/admin/categories',
      builder: (context, state) => const AdminCandleTypeScreen(),
      ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const AdminUsersScreen(),
      ),   
    GoRoute(
      path: '/aprobada',
      builder: (context, state) => const ApprovedScreen(),
    ),
    GoRoute(
      path: '/rechazada',
      builder: (context, state) => const DisapprovedScreen(),
    ),
    GoRoute(
      path: '/crear',
      builder: (context, state) => const CreateAccountScreen(),
    ),

  ],
);