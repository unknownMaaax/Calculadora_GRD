import 'package:app_grd/pages/screen_prueba.dart';
import 'package:app_grd/theme/app_theme.dart';
import 'package:app_grd/widgets/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProcedimientoModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final GlobalKey<_MyAppState> appKey = GlobalKey<_MyAppState>();

  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de GRD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().theme(),
      home: const NuevaScreen(),
    );
  }
}
