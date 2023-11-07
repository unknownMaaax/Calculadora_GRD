import 'package:flutter/material.dart';

class SexoRadioButton extends StatefulWidget {
  const SexoRadioButton({Key? key}) : super(key: key);

  @override
  State<SexoRadioButton> createState() => _SexoRadioButtonState();
}

List<String> sexos = ['Masculino', 'Femenino', 'Otro'];

class _SexoRadioButtonState extends State<SexoRadioButton> {
  String currentOption = sexos[2];
  //falta resetear al poner el ultimo boton
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Masculino'),
          leading: Radio(
            value: sexos[0],
            groupValue: currentOption,
            onChanged: (value) {
              setState(() {
                currentOption = value.toString();
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Femenino'),
          leading: Radio(
            value: sexos[1],
            groupValue: currentOption,
            onChanged: (value) {
              setState(() {
                currentOption = value.toString();
              });
            },
          ),
        )
      ],
    );
  }
}
