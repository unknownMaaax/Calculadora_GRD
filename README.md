# Calculadora GRD

Este es un proyecto con finalidad de desarrollar una aplicacion autocontenida con un modelo de predicción para predecir los grupos relacionados de diagnostico, utilizando las teconologias de Flutter y TFlite principalmente.

## Requerimientos
- [FLutter instalado.](https://docs.flutter.dev/get-started/install)
- [Visual Studio Code](https://code.visualstudio.com/) o editor de codigo de preferencia.
- Una vez creado el proyecto instalar las demendencias necesarias.
 	- [Tflite](https://pub.dev/packages/tflite)
	```
	dependencies:
	          tflite_flutter: version instalada
	```

##Implementación del Modelo Predictivo Tflite
Para comenzar, se debe crear una carpeta llamada assets y ubicarse dentro ( si ya existe la carpeta dirigase dentro de ella), una vez dentro de la carpeta se debe incorporar su modelo predictivo y asegurarse que su extencion se .tflite , luego añadir las dependencias al archivo pubspec.yaml, debera quedar asi:

```
flutter:
    assets:
         - assets/tu-modelo.tflite
```
Ya agregado el modelo al archivo pubspec.yaml, debes importar la libreria tflite en el archivo.dart donde desees utilizar:
```
import 'package:tflite/tflite.dart';
```

```
//Creamos la variable probabilidad para obtener el porcentaje de acierto
String probabilidad = '';
//Crear funcion asíncrona que reciba tus datos de entrada
Future<void>funcionAsync(input){
	//Crear variable interprete
	final interpreter = await Interpreter.fromAsset(
        'assets/tu-modelo.tflite');
	//Definimos la forma de los datos
	var inputShape = interpreter.getInputTensor(0);
	
	//Se guarda la forma de input
	inputShape.setTo(input);
	
	//Especificamos la forma de salida del modelo
	var outputList = List.filled(1 * 210, 0.0);
	var output = [outputList];
	
	//Ejecutamos el interprete
	interpreter.run(inputShape.data, output);
	
	//Buscamos el valor mas alto en la lista de output
	double maximo = output.first
        .reduce((value, element) => value > element ? value : element);
	
	//Buscamos el indice mas alto de la lista obtenida
	int elemento = output.first.indexOf(maximo);
	
	//actualizamos la variable probabilidad para obtener el porcentaje de acierto
	setState(() { 
		probabilidad = output.first[elemento].toString();
	});
	
	print(elemento); //Imprimimos el resultado de la predicción
	print(probabilidad); //Imprimimos el porcentaje de acierto 
}
```