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
  String ed = '';
  String sexo = '';
  String listaFinal = '';
  var listSexo = [];
  var listEdad = [];
  var listPrimerDiagnostico = [];
  String primerDiagnostico = '';
  String probabilidad = '';
  String codigoGRD = '';
  String descripcionGRD = '';
  final diagnostico = TextEditingController();
  final procedimiento = TextEditingController();
  // final sexo = TextEditingController();
  final edad = TextEditingController();

  Future<void> predecirDatos(input) async {
    // Tu código aquí
    final interpreter = await Interpreter.fromAsset(
        'assets/model_satt_sn20231017-211500/convert.tflite');

    var input2 = interpreter.getInputTensor(0);
    var input3 = [
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
    input2.setTo(input3);
    // print(input2);

    var outputList = List.filled(1 * 210, 0.0);
    var output = [outputList];

    interpreter.run(input2.data, output);

    double maximo = output.first
        .reduce((value, element) => value > element ? value : element);

    int elemento = output.first.indexOf(maximo);
    setState(() {
      probabilidad = output.first[elemento].toString();
    });

    // print(elemento);
    // print(probabilidad); //mostrar solo el valor de la probabilidad
    //traduccion de lista grd
    //mostrar probabilidad
    traducir(elemento, probabilidad);
  }

  void traducir(output, probabilidadGRD) async {
    final datosCSV = await rootBundle.loadString('assets/grdsOutput.csv');
    final filaEspecifica = (output);

    List<List<dynamic>> csvTabla = const CsvToListConverter().convert(datosCSV);

    //buscador de fila entregada por el output del modelo para que la muestre al usuario con GRD y Descripcion
    if (filaEspecifica >= 0 && filaEspecifica < csvTabla.length) {
      List<dynamic> filaGuardada = csvTabla[filaEspecifica];
      // print(
      //     "Fila $filaEspecifica: $filaGuardada"); // Imprime la fila específica

      String valorColumna1 = filaGuardada[0]
          .toString(); // Suponiendo que el valor se encuentra en la primera columna
      List<String> valoresSeparados = valorColumna1.split(';');

      if (valoresSeparados.length >= 2) {
        setState(() {
          codigoGRD = valoresSeparados[1];
          descripcionGRD = valoresSeparados[2];
          listaFinal =
              'Se predijo el GRD: $codigoGRD,\n $descripcionGRD \n probabilidad de $probabilidadGRD';
        });

        // print("El GRD predecido es $codigoGRD");
        // print("Otra variable: $descripcionGRD");
      } else {
        // print("No se encontraron valores separados en la columna 1.");
      }
    } else {
      // print("El índice de fila especificado está fuera de rango.");
    }
  }

  //hombre 1, mujer 0

  bool _valueHombre = false;
  bool _valueMujer = false;

  List combinacionInput = [];

  @override
  Widget build(BuildContext context) {
    List<String>? procedimiento =
        Provider.of<ProcedimientoModel>(context).procedimiento;
    List<String>? diagnostico =
        Provider.of<ProcedimientoModel>(context).diagnostico;
    return Scaffold(
      body: ListView(
        children: [
          appBar(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingrese los Diagnosticos:',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const DiagnosticoDropdown(),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingrese los Procedimientos:',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const ProcedimientoDropdown(),
              const SizedBox(height: 5),
              CheckboxListTile(
                title: const Text('Hombre'),
                value: _valueHombre,
                onChanged: (value) {
                  setState(() {
                    _valueHombre = value!;
                    _valueMujer = false;
                    sexo = value ? '1' : '';
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
                    sexo = value ? '0' : '';
                  });
                },
              ),
              InputEdad(edad: edad),
              const SizedBox(height: 5),
              Container(
                // padding: const EdgeInsets.all(25),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    ed = edad.text;

                    if (listEdad.length <= 1 && listSexo.length <= 1) {
                      if (ed != '' && sexo != '') {
                        listEdad.add(ed);
                        listSexo.add(sexo);
                      }
                    }

                    // print("sexo $listSexo");
                    // print("edad $listEdad");
                    //Añadir espacios en blanco a diagnostico y procedimiento
                    //concatenar listas
                    //enviar la lista a funcion predecir
                    //enviar valor de predecir a traducir
                    //resultado de traducir mostrar en pantalla EN UN BOX
                    //!funciona solo si no es nulo
                    if (diagnostico != null) {
                      primerDiagnostico = diagnostico[0];
                      listPrimerDiagnostico.add(primerDiagnostico);
                      for (int i = 0; diagnostico.length < 35; i++) {
                        diagnostico.add('');
                      }
                    }
                    if (procedimiento != null) {
                      for (int i = 0; procedimiento.length < 30; i++) {
                        procedimiento.add('');
                      }
                    }

                    print("diag $diagnostico");
                    print("proc $procedimiento");
                    print("primer $primerDiagnostico");
                    //concatenar listas
                    if (diagnostico != null && procedimiento != null) {
                      var combinacionInput = [
                        ...diagnostico,
                        ...procedimiento,
                        ...listPrimerDiagnostico,
                        ...listSexo,
                        ...listEdad
                      ];
                      print(combinacionInput);
                    }
                    // interpreter.run(input, output);
                    // print(output);
                    //!ENVIAR SOLO UN DATO A LA FUNCION PREDECIR (combinacionInput)
                    predecirDatos(combinacionInput);
                  },
                  child: const Text('Predecir'),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // 90% del ancho de la pantalla
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  listaFinal, // *'Probabilidad : $probabilidad',y el GRD obtenido y descripcion
                  style: const TextStyle(
                      fontSize: 15.0), // Tamaño de texto más grande
                ),
              ),
            ]),
          )
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
    return TextField(
      controller: edad,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Edad',
      ),
    );
  }
}
