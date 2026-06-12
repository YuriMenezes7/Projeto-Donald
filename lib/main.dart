import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'models/cart_manager.dart';

void main() {
  // ✅ Inicializa o CartManager globalmente
  CartManager.instance;
  runApp(const PharmaApp());
}

class PharmaApp extends StatelessWidget {
  const PharmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planck Pharma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A86B),
          primary: const Color(0xFF00A86B),
          secondary: const Color(0xFF0073E6),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(),
    );
  }
}
