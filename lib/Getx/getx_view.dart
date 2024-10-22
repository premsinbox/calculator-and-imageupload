import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Getx/getxcalcbutton.dart';
import 'getx_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class GetxCalcApp extends StatelessWidget {
  const GetxCalcApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.put(CalculatorController());

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
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              child: Text(
                                controller.result.value,
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
                              controller.expression.value,
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
                    }),
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
