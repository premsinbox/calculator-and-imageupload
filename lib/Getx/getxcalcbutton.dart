import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'getx_controller.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final Color fillColor;
  final Color textColor;
  final double textSize;
  final BoxConstraints constraints;

  const CalcButton({
    required this.text,
    required this.fillColor,
    required this.textColor,
    required this.textSize,
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();
    double buttonSize = constraints.maxWidth / 5;
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: fillColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => _handleButtonPress(controller),
        child: _buildButtonContent(),
      ),
    );
  }

  void _handleButtonPress(CalculatorController controller) {
    switch (text) {
      case 'C':
        controller.allClear();
        break;
      case '\u232B':
        controller.erase();
        break;
      case '=':
        controller.evaluateFinal();
        break;
      default:
        controller.numClick(text);
    }
  }

  Widget _buildButtonContent() {
    if (text == '\u232B') {
      return const Icon(Icons.backspace, color: Colors.black, size: 30);
    } else if (text == '00') {
      return FittedBox(
        fit: BoxFit.contain,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '0',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(
                  fontSize: textSize,
                  color: textColor,
                ),
              ),
            ),
            Text(
              '0',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(
                  fontSize: textSize,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text,
          style: GoogleFonts.rubik(
            textStyle: TextStyle(
              fontSize: textSize,
              color: textColor,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
