import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'package:provider/provider.dart';
import 'services/timer_service.dart'; // 👈 très important


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mjkzfhobtnpnksrqboqp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1qa3pmaG9idG5wbmtzcnFib3FwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE0NjQwMzEsImV4cCI6MjA2NzA0MDAzMX0.MGkeAJAa81iS02pa3EvS44sZq7jNi3-6HX_oY4vZkks',
    authFlowType: AuthFlowType.pkce,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => TimerService(),
      child: const PomodoroApp(),
    ),
  );
}



class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Desktop App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        primaryColor: Colors.redAccent,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.redAccent),
      ),
      home: const AuthGate(),
    );
  }
}

/// Widget de redirection selon si l'utilisateur est connecté
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final user = Supabase.instance.client.auth.currentUser;

    if (session == null) {
      return const LoginPage();
    } else if (user != null && user.emailConfirmedAt == null) {
      return const _UnverifiedEmailScreen();
    } else {
      return const HomePage();
    }
  }
}


class _UnverifiedEmailScreen extends StatelessWidget {
  const _UnverifiedEmailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vérification Email")),
      body: const Center(
        child: Text(
          "Veuillez vérifier votre adresse email.\nUn lien vous a été envoyé.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

