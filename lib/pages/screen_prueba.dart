import 'package:app_grd/main.dart';
import 'package:app_grd/widgets/diagnostico_text.dart';
import 'package:app_grd/widgets/edad_text.dart';
import 'package:app_grd/widgets/model.dart';
import 'package:app_grd/widgets/procedimiento_text.dart';
import 'package:app_grd/widgets/sexo_radiobutton.dart';
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
  double ed = 0.0;
  // double sexo = 0.0;
  String listaFinal = '';
  List<num> listSexo = [];
  List<num> listEdad = [];
  List<num> listDiagnosticos = [];
  List<num> listProcedimientos = [];
  var listPrimerDiagnostico = [];
  num primerDiagnostico = 0.0;
  String probabilidad = '';
  String codigoGRD = '';
  String descripcionGRD = '';
  final edad = TextEditingController();

  // bool _valueHombre = false;
  // bool _valueMujer = false;

  double? procedimiento;

  Future<void> predecirDatos(input) async {
    // Tu código aquí
    final interpreter = await Interpreter.fromAsset(
        'assets/model_satt_sn20231017-211500/convert.tflite');

    var inputShape = interpreter.getInputTensor(0);

    var input3 = [
      1010,
      877.0,
      529,
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

    inputShape.setTo(input);

    var outputList = List.filled(1 * 210, 0.0);
    var output = [outputList];

    interpreter.run(inputShape.data, output);

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
    interpreter.close();
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
          // descripcionGRD = valoresSeparados[2];
          listaFinal =
              'Se predijo el GRD: $codigoGRD,\n $descripcionGRD \nPrecisión de: $probabilidadGRD';
        });

        print("El GRD predecido es $codigoGRD");
        // print("Otra variable: $descripcionGRD");
      }
    }
  }

  //hombre 0, mujer 1
  void reiniciarVariablesLocales() {
    setState(() {
      ed = 0.0;
      // sexo = 0.0;
      listaFinal = '';
      listSexo = [];
      listEdad = [];
      listPrimerDiagnostico = [];
      primerDiagnostico = 0.0;
      probabilidad = '';
      codigoGRD = '';
      descripcionGRD = '';
      // _valueHombre = false;
      // _valueMujer = false;
    });
  }

  List combinacionInput = [];

  @override
  Widget build(BuildContext context) {
    List<num>? diagnostico =
        Provider.of<ProcedimientoModel>(context).diagnostico;
    List<num>? procedimiento =
        Provider.of<ProcedimientoModel>(context).procedimiento;
    double? sexo = Provider.of<ProcedimientoModel>(context).sexo;
    double? edad = Provider.of<ProcedimientoModel>(context).edad;
    // List<double> listaCodigosProcedimiento =
    //     Provider.of<ProcedimientoModel>(context).listaCodigosProcedimiento;

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
              const SexoButtonState(),
              const SizedBox(height: 5),
              const InputEdad(),
              const SizedBox(height: 5),
              Container(
                // padding: const EdgeInsets.all(25),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    double? temp = edad;
                    if (temp != null) {
                      ed = temp;
                    } else {
                      ed = 0.0;
                    }
                    if (ed != null) {
                      listEdad.clear();
                      listEdad.add(ed);
                    }
                    if (sexo != null) {
                      listSexo.clear();
                      listSexo.add(sexo as num);
                    }
                    //!funciona solo si no es nulo
                    if (diagnostico != null && diagnostico.length <= 34) {
                      if (diagnostico[0] >= 1.0) {
                        primerDiagnostico = diagnostico[0];
                        listPrimerDiagnostico.add(primerDiagnostico);
                      }
                      for (int i = 0; diagnostico.length <= 34; i++) {
                        diagnostico.add(0.0);
                      }
                    }
                    if (procedimiento != null && procedimiento.length <= 29) {
                      for (int i = 0; procedimiento.length <= 29; i++) {
                        procedimiento.add(0.0);
                      }
                    }

                    print("diag $listDiagnosticos");
                    print("proc $listProcedimientos");
                    print("primer $primerDiagnostico");
                    //concatenar listas
                    if (diagnostico != null && procedimiento != null) {
                      print("entro");

                      List<num> combinacionInput = [
                        ...diagnostico,
                        ...procedimiento,
                        ...listPrimerDiagnostico,
                        ...listEdad,
                        ...listSexo
                      ];
                      print(combinacionInput.length);
                      print("aaaa $combinacionInput");
                      predecirDatos(combinacionInput);
                    }

                    print(listEdad);
                    print("sexo: $listSexo");

                    //!ENVIAR SOLO UN DATO A LA FUNCION PREDECIR (combinacionInput)
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
                  child: Column(children: [
                    const Text(
                      'Prediccion GRD:',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      listaFinal, // *'Probabilidad : $probabilidad',y el GRD obtenido y descripcion
                      style: const TextStyle(
                          fontSize: 15.0), // Tamaño de texto más grande
                    ),
                  ])),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Provider.of<ProcedimientoModel>(context, listen: false)
                      .reset();
                  listDiagnosticos.clear();
                  listProcedimientos.clear();
                  procedimiento?.clear();
                  diagnostico?.clear();
                  listSexo.clear();
                  listEdad.clear();

                  edad = null;
                  setState(() {
                    listaFinal = '';
                  });
                  combinacionInput.clear();
                  primerDiagnostico = 0.0;
                  listPrimerDiagnostico.clear();

                  print("presionado");
                  print("1: $listDiagnosticos");
                  print("2: $listProcedimientos");
                  print("1.a: $diagnostico");
                  print("2.a: $procedimiento");
                  print("3: $listSexo");
                  print("4: $listEdad");
                  print("5: $combinacionInput");
                  print("6: $primerDiagnostico");
                  print("7: $listPrimerDiagnostico");
                },
                child: const Text('Reiniciar'),
              )
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
