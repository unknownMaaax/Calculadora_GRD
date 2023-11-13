import 'dart:convert';
import 'dart:io';
import 'package:app_grd/pages/screen_prueba.dart';
import 'package:app_grd/widgets/model.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:provider/provider.dart';

List countriesList = [
  'Fiebre',
  'caca',
  'peo',
  'A02.8;OTRAS INFECCIONES ESPECIFICADAS COMO DEBIDAS A SALMONELLA',
  'Indonesia'
];
String itemSelected = '';
String diagnostico = '';
List<String> listDiagnosticos = [];

class DiagnosticoDropdown extends StatefulWidget {
  const DiagnosticoDropdown({super.key});

  @override
  State<DiagnosticoDropdown> createState() => _DiagnosticoDropdownState();
}

class _DiagnosticoDropdownState extends State<DiagnosticoDropdown> {
  void _loadCsv() async {
    String data = await rootBundle.loadString("assets/nuevoDiagnostico.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);

    // Inicializa _data como una lista de cadenas
    List<String> _data = data.split('\n');
    for (var row in csvTable) {
      _data.add(row.join(';')); // Agrega cada fila como una cadena a _data
    }
    setState(() {
      _data = _data;
    });
    listDiagnosticos = _data;
  }

  void buscarDiagnostico(String diagnostico) async {
    try {
      String csvString = await rootBundle.loadString('assets/diag.csv');
      List<String> lines = LineSplitter.split(csvString).toList();
      String targetValue = diagnostico;
      String? resultRow;
      print("Función $diagnostico");

      for (var row in lines) {
        final values = row.split(';');
        // print("Values: $values");
        if (values.length >= 3 && values[2].trim() == targetValue.trim()) {
          resultRow = row;
          break;
        }
      }
      if (resultRow != null) {
        print('Fila encontrada: $resultRow');

        // Ahora puedes separar los datos usando el punto y coma
        List<String> datos = resultRow.split(';');
        String codigo = datos[0];
        String valor = datos[1];
        String procedimiento = datos[2];

        print('Código: $codigo');
        print('Valor: $valor');
        print('Procedimiento: $procedimiento');
        // Agrega más líneas según sea necesario para procesar los datos.
      } else {
        print('No se encontró la fila con el procedimiento deseado.');
      }
    } catch (e) {
      print('Error al leer el archivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadCsv();
    return Column(children: [
      DropdownSearch<dynamic>(
        items: listDiagnosticos,
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
          diagnostico = itemSelected;
          buscarDiagnostico(diagnostico);
          //enviar datos a pantalla incial para funcion de predecir
          Provider.of<ProcedimientoModel>(context, listen: false)
              .setDiagnostico(diagnostico);
          itemSelected = '';
          //!diagnostico traducir a codigo de csv
          //!rellenar la lista de diagnosticos a 35 elementos
          //*enviar datos a ScreenPrueba para funcion de predecir
        },
        child: const Text('Agregar'),
      )
    ]);
  }
}
