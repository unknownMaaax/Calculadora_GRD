import 'package:app_grd/widgets/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SexoButtonState extends StatefulWidget {
  const SexoButtonState({super.key});

  @override
  State<SexoButtonState> createState() => _SexoButtonStateState();
}

class _SexoButtonStateState extends State<SexoButtonState> {
  bool _valueHombre = false;
  bool _valueMujer = false;
  double sexo = 0.0;
  @override
  Widget build(BuildContext context) {
    final procedimientoModel = Provider.of<ProcedimientoModel>(context);

    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Hombre'),
          value: _valueHombre,
          onChanged: (value) {
            setState(() {
              _valueHombre = value!;
              _valueMujer = false;
              sexo = value ? 0.0 : 1.0;
            });
            Provider.of<ProcedimientoModel>(context, listen: false)
                .setSexo(sexo);
          },
        ),
        CheckboxListTile(
          title: const Text('Mujer'),
          value: _valueMujer,
          onChanged: (value) {
            setState(() {
              _valueMujer = value!;
              _valueHombre = false;
              sexo = value ? 1.0 : 0.0;
            });
            Provider.of<ProcedimientoModel>(context, listen: false)
                .setSexo(sexo);
          },
        ),
      ],
    );
  }
}
