import 'package:flutter/material.dart';

class procedimientoTextField extends StatelessWidget {
  const procedimientoTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(filled: true, fillColor: Colors.blueGrey),
    );
  }
}
