import 'dart:convert';
import 'dart:io';
import 'package:app_grd/pages/screen_prueba.dart';
import 'package:app_grd/widgets/model.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

List countriesList = [
  'Fiebre',
  'caca',
  'peo',
  'A02.8;OTRAS INFECCIONES ESPECIFICADAS COMO DEBIDAS A SALMONELLA',
  'Indonesia'
];
String itemSelected = '';
String procedimiento = '';
var listProcedimientos = [];

// void lista() async {
//   final datosCSV = await rootBundle.loadString('assets/diag.csv');
//   List<List<dynamic>> csvDiag = const CsvToListConverter().convert(datosCSV);

//   print('Contenido del archivo:');
//   print(csvDiag);
// }

class ProcedimientoDropdown extends StatefulWidget {
  const ProcedimientoDropdown({super.key});

  @override
  State<ProcedimientoDropdown> createState() => _ProcedimientoDropdownState();
}

class _ProcedimientoDropdownState extends State<ProcedimientoDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DropdownSearch<dynamic>(
        // we can pass string to it as well but then we've to make
        // sure that the list of items are string like this List<String>
        items: countriesList,
        onChanged: (value) {
          setState(() {
            itemSelected = value.toString();
          });
        },

        popupProps: const PopupProps.menu(
          showSearchBox: true,
        ),
        selectedItem: itemSelected,
      ),
      const SizedBox(height: 5),
      ElevatedButton(
        onPressed: () {
          procedimiento = itemSelected;
          // print(procedimiento);

          Provider.of<ProcedimientoModel>(context, listen: false)
              .setProcedimiento(procedimiento);
          // Haz lo mismo para diagnostico si es necesario

          // listProcedimientos.add(procedimiento);
          // print(listProcedimientos);

          //diagnostico traducir a codigo de csv
          //codigo csv añadir a lista diagnostico
          // rellenar la lista de diagnosticos a 35 elementos
          //enviar datos a ScreenPrueba para funcion de predecir
          // print(diagnostico);
          // lista();
        },
        child: const Text('Agregar'),
      )
    ]);
  }
}
