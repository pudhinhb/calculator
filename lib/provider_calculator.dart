import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(home: ProviderCalculatorScreen()));
}

class ProviderCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: CalculatorUI(),
    );
  }
}

class CalculatorProvider extends ChangeNotifier {
  String _output = "0";
  String _equation = '';
  double _result = 0;
  String _operator = '';
  bool _isOperatorPressed = false;

  String get output => _output;
  String get equation => _equation;

  void addNumber(String number) {
    if (_isOperatorPressed) {
      _output = number;
      _isOperatorPressed = false;
    } else {
      _output = _output == "0" ? number : _output + number;
    }
    notifyListeners();
  }

  void addOperator(String operator) {
    if (_output.isEmpty) return;
    if (_isOperatorPressed) {
      _operator = operator;
      _equation = "${_equation.substring(0, _equation.length - 1)} $operator";
    } else {
      if (_operator.isNotEmpty) {
        calculate();
      }
      _operator = operator;
      _equation = "$_output $operator";
      _result = double.parse(_output);
      _isOperatorPressed = true;
    }
    notifyListeners();
  }

  void calculate() {
    if (_operator.isEmpty) return;
    int currentNumber = int.parse(_output);
    switch (_operator) {
      case "+":
        _result += currentNumber;
        break;
      case "-":
        _result -= currentNumber;
        break;
      case "×":
        _result *= currentNumber;
        break;
      case "÷":
        if (currentNumber == 0) {
          _output = "Error";
          _operator = '';
          notifyListeners();
          return;
        } else {
          _result /= currentNumber;
        }
        break;
    }
    _output = _result == _result.toInt() ? _result.toInt().toString() : _result.toString();
    _equation += " $currentNumber =";  
    _operator = '';
    _isOperatorPressed = false;
    notifyListeners();
  }

  void clear() {
    _output = "0";
    _equation = '';
    _result = 0;
    _operator = '';
    _isOperatorPressed = false;
    notifyListeners();
  }

  void addDecimal() {
    if (!_output.contains('.')) {
      _output += '.';
    }
    notifyListeners();
  }

  void deleteLastCharacter() {
    if (_output.length > 1) {
      _output = _output.substring(0, _output.length - 1);
    } else {
      clear();
    }
    notifyListeners();
  }
}

class CalculatorUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calculator = Provider.of<CalculatorProvider>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonSize = screenHeight / 11; 
    final double textSize = screenHeight / 20;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white70,
                padding: const EdgeInsets.all(50.0),
                alignment: Alignment.center,
                child: Text(
                  'CALCULATOR',
                   style: TextStyle(fontSize: textSize * 0.6, color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
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
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      calculator.output,
                      style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      calculator.equation,
                      style: TextStyle(fontSize: textSize * 0.6, color: Colors.grey),
                    ),
                  ],
                ),
              ),

             
            ],
          );
        },
      ),
    );
  }

  Widget _buildButtonRow(CalculatorProvider calculator, List<String> labels, double buttonSize,
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
      padding: EdgeInsets.all(size * 0.1),
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
                ? Icon(Icons.backspace, color: textColor, size: size * 0.5)
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: size * 0.4,
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
