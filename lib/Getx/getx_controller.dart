import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorController extends GetxController {
  RxString expression = ''.obs;
  RxString result = ''.obs;

  void numClick(String text) {
    if (_isValidInput(text)) {
      expression.value += text;
      evaluate(); // Automatically evaluate after adding new text
    }
  }

  bool _isValidInput(String text) {
    if (expression.isEmpty) {
      return text != '+' && text != '-' && text != '\u00D7' && text != '\u00F7';
    }
    String lastChar = expression.value[expression.value.length - 1];
    return !(isOperator(text) && isOperator(lastChar));
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
      expression.value = expression.value.substring(0, expression.value.length - 1);
    }
    evaluate(); // Re-evaluate after erasing
  }

  String formatResult(double result) {
    String formatted = result.toString();
    RegExp regExp = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    formatted = formatted.replaceAllMapped(regExp, (Match match) => "${match[1]},");
    if (result % 1 == 0) {
      return formatted.split('.')[0];
    }
    return formatted;
  }

  void evaluate() {
    if (expression.isEmpty) {
      result.value = '';
      return; // Prevent evaluating an empty expression
    }

    // Prevent evaluation if the last character is an operator
    String lastChar = expression.value[expression.value.length - 1];
    if (isOperator(lastChar)) {
      result.value = '';
      return; // Don't evaluate incomplete expressions
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(
          expression.value.replaceAll('\u00D7', '*').replaceAll('\u00F7', '/'));
      ContextModel cm = ContextModel();
      double evalResult = exp.evaluate(EvaluationType.REAL, cm);
      result.value = formatResult(evalResult);
    } catch (e) {
      result.value = 'Error';
    }
  }
}
