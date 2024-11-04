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
          final buttonSize = constraints.maxHeight / 10;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white70,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Image.network(
                  'https://s3-eu-west-1.amazonaws.com/tpd/logos/5e904d09bf6eb70001f7b109/0x0.png',
                  height: 150,
                ),
              ),

              Column(
                children: [
                  _buildButtonRow(calculator, ["C", "%", "⌫", "÷"], buttonSize, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, ["7", "8", "9", "×"], buttonSize, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, ["4", "5", "6", "-"], buttonSize, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, ["1", "2", "3", "+"], buttonSize, operatorColor: Colors.orange),
                  _buildButtonRow(calculator, [".", "0", "00", "="], buttonSize, operatorColor: const Color.fromARGB(255, 33, 37, 243)),
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
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                    Obx(() => Text(
                      calculator.equation.value,
                      style: TextStyle(fontSize: 24, color: Colors.grey),
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

  Widget _buildButtonRow(GetXCalculatorController calculator, List<String> labels, double buttonSize,
      {required Color operatorColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) {
        Color buttonColor;

        if (["÷", "×", "-", "+", "="].contains(label)) {
          buttonColor = operatorColor;
        } else {
          buttonColor = Colors.grey[200]!;
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

  CalculatorButton(this.label, this.onTap, {this.color = Colors.grey, this.textColor = Colors.black, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
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
                      fontSize: 38,
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}