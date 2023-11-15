import 'dart:convert';
import 'dart:ffi';
import 'package:app_grd/widgets/model.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

String itemSelected = '';
String diagnostico = '';
List<String> listDiagnosticos = [];
String codigo = '';
List<double> listaCodigos = [];

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

  Future<double?> buscarDiagnostico(String diagnostico) async {
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
        codigo = datos[0];
        print('Código: $codigo');
        // Agrega más líneas según sea necesario para procesar los datos.
      } else {
        // print('No se encontró la fila con el procedimiento deseado.');
      }
    } catch (e) {
      // print('Error al leer el archivo: $e');
    }
    return double.parse(codigo);
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
        dropdownButtonProps: const DropdownButtonProps(
          color: Colors.blue,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          )),
        ),
        selectedItem: itemSelected,
      ),
      const SizedBox(height: 5),
      ElevatedButton(
        onPressed: () async {
          diagnostico = itemSelected;
          //*traducimos el codigo de diagnostico
          double? codigoDiag = (await buscarDiagnostico(diagnostico));
          if (listDiagnosticos.length != 35 &&
              codigoDiag != null &&
              diagnostico != '') {
            listaCodigos.add(codigoDiag);
            print(listaCodigos);
          }

          ///*enviar datos a ScreenPrueba para funcion de predecir
          Provider.of<ProcedimientoModel>(context, listen: false)
              .setDiagnostico(listaCodigos);
          itemSelected = '';
          //!rellenar la lista de diagnosticos a 35 elementos en pantalla inicia
        },
        child: const Text('Agregar'),
      )
    ]);
  }
}
