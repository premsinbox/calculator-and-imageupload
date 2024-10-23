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
      notifyListeners();
      evaluate();
    }
  }

  bool _isValidInput(String text) {
    if (_expression.isEmpty) {
      return text.contains(RegExp(r'[0-9.]'));
    }

    String lastChar = _expression[_expression.length - 1];

    if (text == '.') {
      List<String> numbers = _expression.split(RegExp(r'[+\-×÷]'));
      String currentNumber = numbers.last;

      return !currentNumber.contains('.');
    }

    if (lastChar == '.' && isOperator(text)) {
      return false;
    }

    if (isOperator(text) && isOperator(lastChar)) {
      return false;
    }

    return true;
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
      evaluate();
    }
  }

  String formatResult(double result) {
    if (result.isInfinite || result.isNaN) {
      return 'Error';
    }

    String formatted = result.toString();

    if (formatted.contains('e')) {
      return result.toStringAsFixed(10).replaceAll(RegExp(r'\.?0+$'), '');
    }

    RegExp regExp = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    formatted =
        formatted.replaceAllMapped(regExp, (Match match) => "${match[1]},");

    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'\.?0+$'), '');
    }

    return formatted;
  }

  void evaluate() {
    if (_expression.isEmpty) {
      _result = '';
      notifyListeners();
      return;
    }

    String lastChar = _expression[_expression.length - 1];
    if (isOperator(lastChar) || lastChar == '.') {
      notifyListeners();
      return;
    }

    try {
      String cleanExpression =
          _expression.replaceAll('\u00D7', '*').replaceAll('\u00F7', '/');

      Parser p = Parser();
      Expression exp = p.parse(cleanExpression);
      ContextModel cm = ContextModel();
      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      // Handle division by zero
      if (evalResult.isInfinite || evalResult.isNaN) {
        _result = 'Error';
      } else {
        _result = formatResult(evalResult);
      }
    } catch (e) {
      _result = 'Error';
    }

    notifyListeners();
  }
}
