import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Provider/provider_controller.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class CalcApp extends StatelessWidget {
  const CalcApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _buildKeypadRow(
                            ['C', '%', '\u232B', '\u00F7'], constraints),
                        _buildKeypadRow(['7', '8', '9', '\u00D7'], constraints),
                        _buildKeypadRow(['4', '5', '6', '-'], constraints),
                        _buildKeypadRow(['1', '2', '3', '+'], constraints),
                        _buildKeypadRow(['.', '0', '00', '='], constraints),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Consumer<CalculatorModel>(
                      builder: (context, calculator, child) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Text(
                                  calculator.result,
                                  style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      color: blackColor,
                                    ),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Text(
                                calculator.expression,
                                style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 103, 103, 103),
                                  ),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> buttons, BoxConstraints constraints) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((String button) {
          return CalcButton(
            text: button,
            fillColor: _getFillColor(button),
            textColor: _getTextColor(button),
            textSize: _getTextSize(button),
            constraints: constraints,
          );
        }).toList(),
      ),
    );
  }

  Color _getFillColor(String button) {
    if (button == 'C' || button == '%' || button == '\u232B') {
      return greyColor;
    } else if (button == '\u00F7' ||
        button == '\u00D7' ||
        button == '-' ||
        button == '+') {
      return secondaryColor;
    } else if ('='.contains(button)) {
      return primaryColor;
    } else {
      return const Color.fromARGB(255, 241, 244, 252);
    }
  }

  Color _getTextColor(String button) {
    if ('\u00F7\u00D7-+='.contains(button)) {
      return whiteColor;
    }
    return blackColor;
  }

  double _getTextSize(String button) {
    switch (button) {
      case '+':
      case '-':
      case '\u00F7':
      case '\u00D7':
        return 45;
      case '00':
        return 36;
      default:
        return 35;
    }
  }
}

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
