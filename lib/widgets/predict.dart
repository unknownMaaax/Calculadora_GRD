import 'dart:io';
import 'package:csv/csv.dart';

void traducir() async {
  final inputFile = File(
      'data/grdsOutput.csv'); // Reemplaza 'tu_archivo.csv' con la ruta de tu archivo CSV

  if (await inputFile.exists()) {
    final csvContent = await inputFile.readAsString();
    const csvConverter = CsvToListConverter();
    final csvList = csvConverter.convert(csvContent);

    const valorABuscar =
        '56'; // Reemplaza 'valor_deseado' con el valor que deseas buscar

    for (var row in csvList) {
      for (var cell in row) {
        if (cell == valorABuscar) {
          print('Valor encontrado en la fila: $row');
          break;
        }
      }
    }
  } else {
    print('El archivo CSV no existe.');
  }
}
