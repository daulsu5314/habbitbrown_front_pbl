import 'package:flutter/material.dart';

// login
import 'screens/login/login_screen.dart';

// auth
import 'screens/auth/signup_screen.dart';
import 'screens/auth/profile_setup.dart';

// home
import 'screens/home/home_screen.dart';

void main() => runApp(const HabitBrownApp());

class HabitBrownApp extends StatelessWidget {
  const HabitBrownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',  // 앱 시작하면 무조건 로그인 화면
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/profileSetup': (_) => const ProfileSetupScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}

