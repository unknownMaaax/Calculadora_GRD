import 'dart:convert';
import 'package:app_grd/widgets/model.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

String itemSelected = '';
String procedimiento = '';
String procedimientoTraducido = '';
List<String> listProcedimientos = [];
int codigo = 0;
List<String> listaCodigosProcedimiento = [];

class ProcedimientoDropdown extends StatefulWidget {
  const ProcedimientoDropdown({super.key});

  @override
  State<ProcedimientoDropdown> createState() => _ProcedimientoDropdownState();
}

class _ProcedimientoDropdownState extends State<ProcedimientoDropdown> {
  void _loadCsv() async {
    String data = await rootBundle.loadString("assets/nuevoProcedimiento.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);

    // Inicializa _data como una lista de cadenas
    List<String> _data = data.split('\n');
    for (var row in csvTable) {
      _data.add(row.join(';')); // Agrega cada fila como una cadena a _data
    }
    setState(() {
      _data = _data;
    });
    listProcedimientos = _data;
    // print(listProcedimientos[1]);
  }

  Future<String?> buscarProcedimiento(String procedimientoFunc) async {
    try {
      String csvString = await rootBundle.loadString('assets/proc.csv');
      List<String> lines = LineSplitter.split(csvString).toList();
      String targetValue = procedimientoFunc;
      String? resultRow;
      print("Función $procedimientoFunc");
      for (var row in lines) {
        final values = row.split(';');
        // print("Values: $values");

        if (values.length >= 3 && values[2].trim() == targetValue.trim()) {
          resultRow = row;
          break;
        }
      }
      if (resultRow != null) {
        // print('Fila encontrada: $resultRow');
        // Ahora puedes separar los datos usando el punto y coma
        List<String> datos = resultRow.split(';');

        codigo = (int.parse(datos[0]) + 3648);
        print('Código: $codigo');
        // Agrega más líneas según sea necesario para procesar los datos.
      } else {
        // print('No se encontró la fila con el procedimiento deseado.');
      }
    } catch (e) {
      // print('Error al leer el archivo: $e');
    }
    return codigo.toString();
  }

  @override
  Widget build(BuildContext context) {
    _loadCsv();
    return Column(children: [
      DropdownSearch<dynamic>(
        items: listProcedimientos,
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
        onPressed: () async {
          procedimiento = itemSelected;
          String? codigoProc = await buscarProcedimiento(procedimiento);
          if (listaCodigosProcedimiento.length != 35 &&
              codigoProc != null &&
              procedimiento != '') {
            listaCodigosProcedimiento.add(codigoProc);
          }
          //*enviar datos a ScreenPrueba para funcion de predecir
          Provider.of<ProcedimientoModel>(context, listen: false)
              .setProcedimiento(listaCodigosProcedimiento);
          itemSelected = '';
          //!rellenar la lista de diagnosticos a 35 elementos en pantalla incial
        },
        child: const Text('Agregar'),
      )
    ]);
  }
}
