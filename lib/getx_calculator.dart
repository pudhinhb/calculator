import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(home: GetXCalculatorScreen()));
}

class GetXCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CalculatorUI();
  }
}

class GetXCalculatorController extends GetxController {
  var output = "0".obs;
  var equation = ''.obs;
  double result = 0;
  String operator = '';
  bool isOperatorPressed = false;

  void addNumber(String number) {
    if (isOperatorPressed) {
      output.value = number;
      isOperatorPressed = false;
    } else {
      output.value = output.value == "0" ? number : output.value + number;
    }
  }

  void addOperator(String operator) {
    if (output.value.isEmpty) return;
    if (isOperatorPressed) {
      this.operator = operator;
      equation.value = equation.value.substring(0, equation.value.length - 1) + " " + operator;
    } else {
      if (this.operator.isNotEmpty) {
        calculate();
      }
      this.operator = operator;
      equation.value = output.value + " " + operator;
      result = double.parse(output.value);
      isOperatorPressed = true;
    }
  }

  void calculate() {
    if (operator.isEmpty) return;
    int currentNumber = int.parse(output.value);
    switch (operator) {
      case "+":
        result += currentNumber;
        break;
      case "-":
        result -= currentNumber;
        break;
      case "×":
        result *= currentNumber;
        break;
      case "÷":
        if (currentNumber == 0) {
          output.value = "Error";
          operator = '';
          return;
        } else {
          result /= currentNumber;
        }
        break;
    }
    output.value = result == result.toInt() ? result.toInt().toString() : result.toString();
    equation.value += " " + currentNumber.toString() + " =";  
    operator = '';
    isOperatorPressed = false;
  }

  void clear() {
    output.value = "0";
    equation.value = '';
    result = 0;
    operator = '';
    isOperatorPressed = false;
  }

  void addDecimal() {
    if (!output.value.contains('.')) {
      output.value += '.';
    }
  }

  void deleteLastCharacter() {
    if (output.value.length > 1) {
      output.value = output.value.substring(0, output.value.length - 1);
    } else {
      clear();
    }
  }
}

class CalculatorUI extends StatelessWidget {
  final GetXCalculatorController calculator = Get.put(GetXCalculatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Dynamically calculate button size based on available height and width
          final buttonSize = constraints.maxHeight / 11; 
          final buttonWidth = constraints.maxWidth / 5; 

          // Dynamically calculate font size based on available screen size
          final outputFontSize = constraints.maxHeight * 0.06;  
          final equationFontSize = constraints.maxHeight * 0.03;  

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white70,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                
              ),
              Column(
                children: [
                  _buildButtonRow(calculator, ["C", "%", "⌫", "÷"], buttonSize, buttonWidth, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, ["7", "8", "9", "×"], buttonSize, buttonWidth, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, ["4", "5", "6", "-"], buttonSize, buttonWidth, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, ["1", "2", "3", "+"], buttonSize, buttonWidth, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, [".", "0", "00", "="], buttonSize, buttonWidth, operatorColor: const Color.fromARGB(255, 33, 37, 243)),
                ],
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                      calculator.output.value,
                      style: TextStyle(fontSize: outputFontSize, fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                    Obx(() => Text(
                      calculator.equation.value,
                      style: TextStyle(fontSize: equationFontSize, color: Colors.grey),
                    )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButtonRow(GetXCalculatorController calculator, List<String> labels, double buttonSize, double buttonWidth, {required Color operatorColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) {
        Color buttonColor;

        if (["÷", "×", "-", "+", "="].contains(label)) {
          buttonColor = operatorColor;
        } else {
          buttonColor = Colors.grey[200]!; // Background color for numbers
        }

        return CalculatorButton(
          label,
          () {
            switch (label) {
              case "C":
                calculator.clear();
                break;
              case "⌫":
                calculator.deleteLastCharacter();
                break;
              case "%":
                calculator.addOperator("%");
                break;
              case "+": case "-": case "×": case "÷":
                calculator.addOperator(label);
                break;
              case "=":
                calculator.calculate();
                break;
              case ".":
                calculator.addDecimal();
                break;
              default:
                calculator.addNumber(label);
                break;
            }
          },
          color: buttonColor,
          textColor: buttonColor == operatorColor ? Colors.white : Colors.black,
          size: buttonSize,
          width: buttonWidth,
        );
      }).toList(),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final double size;
  final double width;

  CalculatorButton(this.label, this.onTap, {this.color = Colors.grey, this.textColor = Colors.black, required this.size, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: label == "⌫"
                ? Icon(Icons.backspace, color: Colors.black)
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: size * 0.5, // Font size dynamically based on button size
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
