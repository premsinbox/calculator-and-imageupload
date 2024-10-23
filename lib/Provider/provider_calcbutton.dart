import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Provider/provider_controller.dart';


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
    double buttonSize = constraints.maxWidth / 5;
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Consumer<CalculatorModel>(
        builder: (context, calculator, child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: fillColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonSize / 2),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: () => _handleButtonPress(context),
            child: _buildButtonContent(),
          );
        },
      ),
    );
  }

  void _handleButtonPress(BuildContext context) {
    final calculator = Provider.of<CalculatorModel>(context, listen: false);
    switch (text) {
      case 'C':
        calculator.allClear();
        break;
      case '\u232B':
        calculator.erase();
        break;
      case '=':
        calculator.evaluate();
        break;
      default:
        calculator.numClick(text);
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
