import 'dart:convert';
import 'package:app_grd/widgets/model.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProcedimientoDropdown extends StatefulWidget {
  const ProcedimientoDropdown({super.key});

  @override
  State<ProcedimientoDropdown> createState() => _ProcedimientoDropdownState();
}

class _ProcedimientoDropdownState extends State<ProcedimientoDropdown> {
  double? codigoProc;
  String itemSelected = '';
  String procedimiento = '';
  String procedimientoTraducido = '';
  List<String> listProcedimientos = [];
  double codigo = 0;
  List<double> listaCodigosProcedimiento = [];

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

  Future<double?> buscarProcedimiento(String procedimientoFunc) async {
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

        double? temp = double.tryParse(datos[0]);
        // print(temp);
        if (temp != null) {
          codigo = temp + 3648.0;
          // print(codigo);
        } else {
          // Maneja el caso en que datos[0] no sea un número válido
          // Por ejemplo, puedes establecer codigo a un valor predeterminado
          codigo = 3648.0;
        }
        // Agrega más líneas según sea necesario para procesar los datos.
      } else {
        // print('No se encontró la fila con el procedimiento deseado.');
      }
    } catch (e) {
      // print('Error al leer el archivo: $e');
    }
    return codigo;
  }

  @override
  Widget build(BuildContext context) {
    _loadCsv();
    final procedimientoModel = Provider.of<ProcedimientoModel>(context);
    // Ahora puedes usar listaCodigos
    List<double> listaCodigosProcedimiento =
        procedimientoModel.listaCodigosProcedimiento;
    return ChangeNotifierProvider(
        create: (context) => ProcedimientoModel(),
        child: Column(children: [
          Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(15),
              child: DropdownSearch<dynamic>(
                items: listProcedimientos,
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
              )),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              procedimiento = itemSelected;
              codigoProc = await buscarProcedimiento(procedimiento);
              if (listaCodigosProcedimiento.length != 35 &&
                  codigoProc != null &&
                  procedimiento != '') {
                listaCodigosProcedimiento.add(codigoProc as double);
                print(listaCodigosProcedimiento);
              }
              //*enviar datos a ScreenPrueba para funcion de predecir
              Provider.of<ProcedimientoModel>(context, listen: false)
                  .setProcedimiento(listaCodigosProcedimiento.cast<double>());
              itemSelected = '';
              //!rellenar la lista de diagnosticos a 35 elementos en pantalla incial
            },
            child: const Text('Agregar'),
          )
        ]));
  }
}
