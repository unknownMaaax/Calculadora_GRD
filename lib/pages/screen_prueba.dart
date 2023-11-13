import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:app_grd/widgets/diagnostico_text.dart';
import 'package:app_grd/widgets/model.dart';
import 'package:app_grd/widgets/procedimiento_text.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class NuevaScreen extends StatefulWidget {
  const NuevaScreen({super.key});

  @override
  State<NuevaScreen> createState() => _NuevaScreenState();
}

class _NuevaScreenState extends State<NuevaScreen> {
  Future<void> miFuncionAsincrona(diagnostico, procedimiento) async {
    // Tu código aquí
    final interpreter = await Interpreter.fromAsset(
        'assets/model_satt_sn20231017-211500/convert.tflite');

    var input2 = interpreter.getInputTensor(0);
    var input = [
      1010.0,
      877.0,
      529.0,
      3595.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      4265.0,
      4354.0,
      4531.0,
      4523.0,
      4362.0,
      4343.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1010.0,
      65.0,
      0.0,
    ];
    input2.setTo(input);
    // print(input2);

    var outputList = List.filled(1 * 210, 0.0);
    var output = [outputList];

    interpreter.run(input2.data, output);

    double maximo = output.first
        .reduce((value, element) => value > element ? value : element);

    int elemento = output.first.indexOf(maximo);

    print(elemento);
    print(output.first[elemento]);
    //traduccion de lista grd
    //mostrar probabilidad
    // traducir(elemento);
    print(diagnostico);
    print(procedimiento);
  }

  final diagnostico = TextEditingController();
  final procedimiento = TextEditingController();
  // final sexo = TextEditingController();
  final edad = TextEditingController();

  String diag = '';
  String proc = '';
  String ed = '';
  String sexo = ''; //hombre 1, mujer 0

  var listDiagnosticos = [];
  //assert(listDiagnosticos.length == 35);
  var listProcedimientos = [];
  var listSexo = [];
  var listEdad = [];

  bool _valueHombre = false;
  bool _valueMujer = false;

  List combinacionInput = [];

  @override
  Widget build(BuildContext context) {
    String procedimiento =
        Provider.of<ProcedimientoModel>(context).procedimiento;
    String diagnostico = Provider.of<ProcedimientoModel>(context).diagnostico;
    return Scaffold(
      body: ListView(
        children: [
          appBar(),
          const DiagnosticoDropdown(),
          const ProcedimientoDropdown(),

          CheckboxListTile(
            title: const Text('Hombre'),
            value: _valueHombre,
            onChanged: (value) {
              setState(() {
                _valueHombre = value!;
                _valueMujer = false;
                sexo = value ? 'H' : '';
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Mujer'),
            value: _valueMujer,
            onChanged: (value) {
              setState(() {
                _valueMujer = value!;
                _valueHombre = false;
                sexo = value ? 'M' : '';
              });
            },
          ),

          InputEdad(edad: edad),
          // ]),
          Container(
            // padding: const EdgeInsets.all(25),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                ed = edad.text;
                listEdad.add(ed);
                listSexo.add(sexo);
                for (int i = 0; listDiagnosticos.length < 35; i++) {
                  listDiagnosticos.add('');
                }
                //concatenar listas
                combinacionInput = [
                  ...listDiagnosticos,
                  ...listProcedimientos,
                  ...listSexo,
                  ...listEdad
                ];
                // print(combinacionInput);
                // interpreter.run(input, output);
                // print(output);
                miFuncionAsincrona(diagnostico, procedimiento);
              },
              child: const Text('Predecir'),
            ),
          ),

          //DropdownDiagnostico(),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Calculadora GRD',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 1.0,
    );
  }
}

//textfield edad
class InputEdad extends StatelessWidget {
  const InputEdad({
    super.key,
    required this.edad,
  });

  final TextEditingController edad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: edad,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Edad',
        ),
      ),
    );
  }
}

void traducir(output) async {
  final datosCSV = await rootBundle.loadString('assets/grdsOutput.csv');
  final filaEspecifica = (output);

  List<List<dynamic>> csvTabla = const CsvToListConverter().convert(datosCSV);

  //buscador de fila entregada por el output del modelo para que la muestre al usuario con GRD y Descripcion
  if (filaEspecifica >= 0 && filaEspecifica < csvTabla.length) {
    List<dynamic> filaGuardada = csvTabla[filaEspecifica];
    print("Fila $filaEspecifica: $filaGuardada"); // Imprime la fila específica

    String valorColumna1 = filaGuardada[0]
        .toString(); // Suponiendo que el valor se encuentra en la primera columna
    List<String> valoresSeparados = valorColumna1.split(';');

    if (valoresSeparados.length >= 2) {
      String codigoGRD = valoresSeparados[1];
      String descripcionGRD = valoresSeparados[2];

      print("El GRD predecido es $codigoGRD");
      print("Otra variable: $descripcionGRD");
    } else {
      print("No se encontraron valores separados en la columna 1.");
    }
  } else {
    print("El índice de fila especificado está fuera de rango.");
  }
}
