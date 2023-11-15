import 'package:app_grd/widgets/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputEdad extends StatefulWidget {
  const InputEdad({
    super.key,
  });

  @override
  State<InputEdad> createState() => _InputEdadState();
}

class _InputEdadState extends State<InputEdad> {
  // late final TextEditingController edad;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) {
        double edad = double.parse(value);
        Provider.of<ProcedimientoModel>(context, listen: false).setEdad(edad);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: 'Edad',
      ),
    );
  }
}
