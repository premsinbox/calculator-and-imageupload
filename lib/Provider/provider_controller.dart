import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorModel extends ChangeNotifier {
  String _expression = '';
  String _result = '';

  String get expression => _expression;
  String get result => _result;

  void numClick(String text) {
    if (_isValidInput(text)) {
      _expression += text;
      notifyListeners(); // Notify listeners after updating expression
      evaluate(); // Automatically evaluate after adding new text
    }
  }

  bool _isValidInput(String text) {
    if (_expression.isEmpty) {
      return text != '+' && text != '-' && text != '\u00D7' && text != '\u00F7';
    }
    String lastChar = _expression[_expression.length - 1];
    return !(isOperator(text) && isOperator(lastChar));
  }

  bool isOperator(String text) {
    return text == '+' || text == '-' || text == '\u00D7' || text == '\u00F7';
  }

  void allClear() {
    _expression = '';
    _result = '';
    notifyListeners();
  }

  void erase() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
      evaluate(); // Evaluate after erasing
    }
  }

  String formatResult(double result) {
    String formatted = result.toString();
    RegExp regExp = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    formatted =
        formatted.replaceAllMapped(regExp, (Match match) => "${match[1]},");
    if (result % 1 == 0) {
      return formatted.split('.')[0];
    }
    return formatted;
  }

  void evaluate() {
    if (_expression.isEmpty) {
      _result = '';
      notifyListeners();
      return; // Prevent evaluating an empty expression
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(
          _expression.replaceAll('\u00D7', '*').replaceAll('\u00F7', '/'));
      ContextModel cm = ContextModel();
      double evalResult = exp.evaluate(EvaluationType.REAL, cm);
      _result = formatResult(evalResult);
    } catch (e) {
      _result = 'Error';
    }

    notifyListeners(); // Notify listeners after evaluation
  }
}
