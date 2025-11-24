import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_final/src/views/about_page.dart';
import 'package:proyecto_final/src/views/login_page.dart';
import 'package:proyecto_final/src/views/register.dart';
import 'package:proyecto_final/src/views/home_page.dart';
import 'package:proyecto_final/src/views/stadistics.dart';
import 'firebase_options.dart';
import 'package:proyecto_final/src/views/admin_book_page.dart';
import 'package:proyecto_final/src/views/start_read_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        redirect: (context, state) {
          final user = FirebaseAuth.instance.currentUser;

          final freeRoutes = ['/register'];

          if (user == null && !freeRoutes.contains(state.fullPath)) {
            return '/login';
          }

          return null;
        },
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => LoginPage(),
          ),
          GoRoute(
            path: '/register',
            name: 'register',
            builder: (context, state) => RegisterPage(),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => HomePage(),

            routes: [
              GoRoute(
                path: '/create',
                name: 'new-book',
                builder: (context, state) => AdminBookPage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'update-book',

                builder: (context, state) {
                  final book = state.extra as Map<String, dynamic>;

                  return AdminBookPage(book: book);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/stadistics',
            name: 'statistics',
            builder: (context, state) => Stadistics(),
          ),
          GoRoute(
            path: '/start',
            name: 'start',
            builder: (context, state) => StartReadPage(),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            builder: (context, state) => AboutPage(),
          ),
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
