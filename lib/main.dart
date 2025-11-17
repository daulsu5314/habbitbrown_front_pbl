import 'package:flutter/material.dart';

// login
import 'screens/login/login_screen.dart';

// auth
import 'screens/auth/signup_screen.dart';
import 'screens/auth/profile_setup.dart';
import 'screens/auth/habit_setting.dart';

// home
import 'screens/home/home_screen.dart';

void main() => runApp(const HabitBrownApp());

class HabitBrownApp extends StatelessWidget {
  const HabitBrownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/habitSetting',  // 앱 시작하면 무조건 로그인 화면
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupPage(),
        '/profileSetup': (_) => const ProfileSetupPage(),
        '/home': (_) => const HomeScreen(),
        '/habitSetting' : (_) => const HabitSetupPage(),

      },
    );
  }
}

