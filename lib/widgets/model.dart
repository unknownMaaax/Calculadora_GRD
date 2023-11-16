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
  String? edadreset;
  List<double> listaCodigos = [];
  List<double> listaCodigosProcedimiento = [];
  bool _valueHombre = false;
  bool _valueMujer = false;

  double? get sexo => _sexo;
  double? get edad => _edad;
  bool get valueHombre => _valueHombre;
  bool get valueMujer => _valueMujer;

  void reset() {
    listaCodigos = [];
    listaCodigosProcedimiento = [];
    edadreset = '';
    _edad = null;
  }

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
    print(diagnostico);
    print(procedimiento);
    notifyListeners();
  }
}
