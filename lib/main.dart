import 'dart:math';

import 'package:flutter/material.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
  Widget build(BuildContext context) {
        return MaterialApp(
            title: "My_Calculator",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
                useMaterial3: true
            ),
            home: const MyCalculatorPage(title: "My_Calculator"),
        );
  }
}

class MyCalculatorPage extends StatefulWidget {
    const MyCalculatorPage({super.key, required this.title});

    final String title;

    @override
    State<MyCalculatorPage> createState() => _MyCalculatorPageState();
}

class _MyCalculatorPageState extends State<MyCalculatorPage> {

  String _display = '0';
  double? _firstOperand;
  String? _operator;
  bool _shouldReset = false;

  void _onDigitPressed(String digit) {
    setState(() {
      if(_display == '0' || _shouldReset ){
        _display = digit;
        _shouldReset = false;
      } else {
        _display += digit;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
        _firstOperand = double.tryParse(_display);
        _operator = operator;
        _shouldReset = true;
    });
  }



  void _percentagePressed() {
    setState(() {
      double current = double.tryParse(_display) ?? 0;

      if (_firstOperand != null && _operator != null) {
        if (_operator == '+' || _operator == '-') {
          current = (_firstOperand! * current) / 100;
        } else if (_operator == 'X' || _operator == '/' || _operator == '^') {
          current = current / 100;
        }
      } else {
        current = current / 100;
      }

      _display = current
          .toStringAsFixed(6)
          .replaceAll(RegExp(r'\.?0+$'), '');

      _shouldReset = true;
    });
  }

  void _calculate() {
    setState(() {
        if(_firstOperand == null || _operator == null) return;
        double secondOperand = double.tryParse(_display) ?? 0;
        double result = 0;

        switch(_operator){
          case '+':
            result = _firstOperand! + secondOperand;
            break;
          case '-':
            result = _firstOperand! - secondOperand;
            break;
          case 'X':
            result = _firstOperand! * secondOperand;
            break;
          case '/':
            result = _firstOperand! / secondOperand;
            break;
          case '^':
            result = pow(_firstOperand!, secondOperand).toDouble();
            break;
        }
        _display = result.toString().replaceAll(RegExp(r'\.0$'), '');
        _firstOperand = null;
        _operator = null;
        _shouldReset = true;
    });
  }

  void _backspace() {
    setState(() {
      _shouldReset = false;
      if(_display.isNotEmpty && _display != '0') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = "0";
        }
      } else if(_operator != null){
        _operator = null;
        _display = _firstOperand.toString().replaceAll(RegExp(r'\.0$'), '') ?? '0';
      } else {
        _firstOperand = null;
        _display = '0';
      }
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstOperand = null;
      _operator = null;
      _shouldReset = false;
    });
  }

  Widget _buildButton(String text, VoidCallback onPressed, {Color ?  color}) {
      return FloatingActionButton(
        onPressed: onPressed,
        child: Text(text , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold)),
        backgroundColor:  color ?? Theme.of(context).colorScheme.primaryContainer,
      );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text(widget.title , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.deepOrange , letterSpacing: 1),),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _display,
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold , color: Colors.deepOrange),
                  ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children : [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _buildButton('AC', _clear , color: Colors.red),
                    _buildButton('/', () => _onOperatorPressed('/'), color: Colors.deepOrange),
                    _buildButton('X', () => _onOperatorPressed('X'), color: Colors.deepOrange),
                    _buildButton('-', () => _onOperatorPressed('-'), color: Colors.deepOrange),
                  ],),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _buildButton('7', () => _onDigitPressed('7')),
                    _buildButton('8', () => _onDigitPressed('8')),
                    _buildButton('9', () => _onDigitPressed('9')),
                    _buildButton('+', () => _onOperatorPressed('+'), color: Colors.deepOrange),
                  ],),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _buildButton('4', () => _onDigitPressed('4')),
                    _buildButton('5', () => _onDigitPressed('5')),
                    _buildButton('6', () => _onDigitPressed('6')),
                    _buildButton('^', () => _onOperatorPressed('^'), color: Colors.deepOrange),
                  ],),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _buildButton('1', () => _onDigitPressed('1')),
                    _buildButton('2', () => _onDigitPressed('2')),
                    _buildButton('3', () => _onDigitPressed('3')),
                    _buildButton('%', _percentagePressed, color: Colors.deepOrange),
                  ],),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _buildButton('0', () => _onDigitPressed('0'),),
                    _buildButton('.', () => _onDigitPressed('.'),),
                    _buildButton('⌫', _backspace , color: Colors.blue),
                    _buildButton('=', _calculate , color: Colors.green),
                  ],),
                ],
              ),
            ),
          ],
        ),
      );
  }
}