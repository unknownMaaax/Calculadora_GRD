// procedimiento_model.dart

import 'dart:ffi';

import 'package:flutter/foundation.dart';

class ProcedimientoModel extends ChangeNotifier {
  List<num>? _procedimiento;
  List<num>? _diagnostico;

  List<num>? get procedimiento => _procedimiento;
  List<num>? get diagnostico => _diagnostico;

  void setProcedimiento(List<num> listaCodigosProcedimiento) {
    _procedimiento = listaCodigosProcedimiento;
    notifyListeners();
  }

  void setDiagnostico(List<num> listaCodigos) {
    _diagnostico = listaCodigos;
    notifyListeners();
  }
}
