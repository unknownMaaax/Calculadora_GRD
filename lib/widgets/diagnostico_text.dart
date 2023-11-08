import 'package:flutter/material.dart';

class DropdownDiagnostico extends StatelessWidget {
  const DropdownDiagnostico({super.key});

  static const List<String> listDiagnosticos = <String>[
    'Diagnostico 1',
    'Diagnostico 2',
    'Diagnostico 3',
    'Diagnostico 4',
    'Diagnostico 5',
    'Diagnostico 6',
    'Diagnostico 766',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return listDiagnosticos.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        print('You just selected $selection');
      },
    );
  }
}
