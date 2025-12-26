import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(prefs)..checkAuth(),
      child: MaterialApp.router(
        title: 'EarnSure',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: _buildRouter(context),
      ),
    );
  }

  GoRouter _buildRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        final isLoggedIn = auth.isAuthenticated;
        final userRole = auth.user?.role;

        print('🔵 ROUTE REDIRECT: isLoggedIn=$isLoggedIn, role=$userRole, path=${state.uri.path}');

        // If going to splash, welcome, login, or register - allow
        if (state.uri.path == '/splash' ||
            state.uri.path == '/welcome' ||
            state.uri.path == '/login' ||
            state.uri.path == '/register') {
          if (isLoggedIn) {
            // Already logged in, redirect to home
            print('✅ Already logged in, redirecting to /home');
            return '/home';
          }
          return null; // Allow navigation
        }

        // If not logged in, redirect to splash
        if (!isLoggedIn) {
          print('❌ Not logged in, redirecting to /splash');
          return '/splash';
        }

        // Logged in and trying to go to home - allow
        if (state.uri.path == '/home') {
          print('✅ Allowing home access for $userRole');
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}
