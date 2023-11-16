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
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final procedimientoModel = Provider.of<ProcedimientoModel>(context);
    _controller.text = procedimientoModel.edad?.toString() ?? '';

    return TextField(
      onSubmitted: (value) {
        double edad = double.parse(value);
        Provider.of<ProcedimientoModel>(context, listen: false).setEdad(edad);
      },
      controller: _controller,
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
