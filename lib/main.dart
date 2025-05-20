import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'productos/carrito_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/carrito': (_) => const CarritoScreen(),
      },
    );
  }
}