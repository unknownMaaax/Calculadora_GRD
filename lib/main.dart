import 'package:app_grd/pages/calculadora_screen.dart';
import 'package:app_grd/pages/screen_prueba.dart';
import 'package:app_grd/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de GRD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().theme(),
      // home: const CalculadoraScreen(),
      home: const NuevaScreen(),
    );
  }
}
