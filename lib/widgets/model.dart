// procedimiento_model.dart

import 'package:flutter/foundation.dart';

class ProcedimientoModel extends ChangeNotifier {
  List<String>? _procedimiento;
  List<String>? _diagnostico;

  List<String>? get procedimiento => _procedimiento;
  List<String>? get diagnostico => _diagnostico;

  void setProcedimiento(List<String> listaCodigosProcedimiento) {
    _procedimiento = listaCodigosProcedimiento;
    notifyListeners();
  }

  void setDiagnostico(List<String> listaCodigos) {
    _diagnostico = listaCodigos;
    notifyListeners();
  }
}
