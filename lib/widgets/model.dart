// procedimiento_model.dart

import 'package:flutter/foundation.dart';

class ProcedimientoModel extends ChangeNotifier {
  String _procedimiento = '';
  String _diagnostico = '';

  String get procedimiento => _procedimiento;
  String get diagnostico => _diagnostico;

  void setProcedimiento(String value) {
    _procedimiento = value;
    notifyListeners();
  }

  void setDiagnostico(String value) {
    _diagnostico = value;
    notifyListeners();
  }
}
