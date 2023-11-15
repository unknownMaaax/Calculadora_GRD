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

  double? _sexo;
  double? _edad;
  final List<double> _listaCodigosProcedimiento = [];

  double? get sexo => _sexo;
  double? get edad => _edad;
  List<double> get listaCodigosProcedimiento => _listaCodigosProcedimiento;

  void setSexo(double? sexoCodigos) {
    _sexo = sexoCodigos;
    notifyListeners();
  }

  void setEdad(double? edadCodigos) {
    _edad = edadCodigos;
    notifyListeners();
  }

  void reiniciarVariablesProvider() {
    _procedimiento = null;
    _diagnostico = null;
    listaCodigosProcedimiento.clear();
    print(diagnostico);
    print(procedimiento);
    notifyListeners();
  }
}
