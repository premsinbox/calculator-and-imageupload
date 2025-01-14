import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorController extends GetxController {
  RxString expression = ''.obs;
  RxString result = ''.obs;

  void numClick(String text) {
    if (_isValidInput(text)) {
      expression.value += text;
      calculatePreview();
    }
  }

  bool _isValidInput(String text) {
    if (expression.isEmpty) {
      // Allow only numbers and negative sign as first character
      return text.contains(RegExp(r'[0-9]')) || text == '-';
    }

    String lastChar = expression.value[expression.value.length - 1];

    // If current input is an operator
    if (isOperator(text) || text == '%') {
      // Check if last character is also an operator or percentage
      return !(isOperator(lastChar) || lastChar == '%' || lastChar == '.');
    }

    // If current input is a decimal point
    if (text == '.') {
      // Split by operators and check the last number
      List<String> numbers = expression.value.split(RegExp(r'[+\-×÷%]'));
      String currentNumber = numbers.last;
      return !currentNumber.contains('.');
    }

    // Allow all other inputs (numbers)
    return true;
  }

  bool isOperator(String text) {
    return text == '+' || text == '-' || text == '\u00D7' || text == '\u00F7';
  }

  void allClear() {
    expression.value = '';
    result.value = '';
  }

  void erase() {
    if (expression.isNotEmpty) {
      expression.value =
          expression.value.substring(0, expression.value.length - 1);
      calculatePreview();
    }
  }

  String formatResult(double result) {
    if (result.isInfinite || result.isNaN) {
      return 'Error';
    }

    String formatted = result.toString();
    RegExp regExp = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    formatted =
        formatted.replaceAllMapped(regExp, (Match match) => "${match[1]},");

    if (result % 1 == 0) {
      return formatted.split('.')[0];
    }
    return formatted;
  }

  void calculatePreview() {
    if (expression.isEmpty) {
      result.value = '';
      return;
    }

    try {
      String evalExp =
          expression.value.replaceAll('\u00D7', '*').replaceAll('\u00F7', '/');

      if (RegExp(r'[0-9]$').hasMatch(evalExp)) {
        Parser p = Parser();
        Expression exp = p.parse(evalExp);
        ContextModel cm = ContextModel();
        double evalResult = exp.evaluate(EvaluationType.REAL, cm);
        result.value = formatResult(evalResult);
      } else {
        result.value = '';
      }
    } catch (e) {
      result.value = '';
    }
  }

  void evaluateFinal() {
    if (expression.isEmpty) {
      result.value = '';
      return;
    }

    try {
      String evalExp =
          expression.value.replaceAll('\u00D7', '*').replaceAll('\u00F7', '/');

      if (RegExp(r'[\+\-\*\/]\.$').hasMatch(evalExp) ||
          evalExp.contains('..') ||
          evalExp.endsWith('.')) {
        result.value = 'Error';
        return;
      }

      Parser p = Parser();
      Expression exp = p.parse(evalExp);
      ContextModel cm = ContextModel();
      double evalResult = exp.evaluate(EvaluationType.REAL, cm);
      result.value = formatResult(evalResult);
    } catch (e) {
      result.value = 'Error';
    }
  }
}
