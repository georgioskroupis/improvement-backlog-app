import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Set initial page to login
      routes: {
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
