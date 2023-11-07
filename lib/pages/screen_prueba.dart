import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class NuevaScreen extends StatefulWidget {
  const NuevaScreen({super.key});

  @override
  State<NuevaScreen> createState() => _NuevaScreenState();
}

class _NuevaScreenState extends State<NuevaScreen> {
  Future<void> miFuncionAsincrona() async {
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
    print(input2);

    var outputList = List.filled(1 * 210, 0.0);
    var output = [outputList];

    var output2 = interpreter.getOutputTensors().first;

    // output2.setTo(output);

    interpreter.run(input2.data, output);

    double maximo = output.first
        .reduce((value, element) => value > element ? value : element);

    int elemento = output.first.indexOf(maximo);

    print(output);
    print(elemento);
    print(output.first[elemento]);
    //traduccion de lista grd
    //mostrar probabilidad
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
    return Scaffold(
      body: ListView(
        children: [
          appBar(),
          InputDiagnostico(diagnostico: diagnostico),
          Container(
            //botonDiagnostico
            // padding: const EdgeInsets.all(25),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                diag = diagnostico.text;
                listDiagnosticos.add(diag);
                print(listDiagnosticos);
              },
              child: const Text('Agregar'),
            ),
          ),
          InputProcedimiento(procedimiento: procedimiento),
          Container(
            // padding: const EdgeInsets.all(25),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                proc = procedimiento.text;
                listProcedimientos.add(proc);
                print(listProcedimientos);
              },
              child: const Text('Agregar'),
            ),
          ),
          // Row(mainAxisAlignment: MainAxisAlignment.center, children: [

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
                miFuncionAsincrona();
              },
              child: const Text('Predecir'),
            ),
          ),
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

//textfield procedimiento
class InputProcedimiento extends StatelessWidget {
  const InputProcedimiento({
    super.key,
    required this.procedimiento,
  });

  final TextEditingController procedimiento;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: procedimiento,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Procedimiento',
        ),
      ),
    );
  }
}

//textfield diagnostico
class InputDiagnostico extends StatelessWidget {
  const InputDiagnostico({
    super.key,
    required this.diagnostico,
  });

  final TextEditingController diagnostico;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: diagnostico,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'G00.0',
        ),
      ),
    );
  }
}