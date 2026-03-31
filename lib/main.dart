import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
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

  String _expression = '0';

  void _onDigitPressed(String digit) {
    setState(() {
      if(_expression == '0'){
        _expression = digit;
      } else {
        _expression += digit;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
        if(_expression.isEmpty) return;
        String last = _expression[_expression.length-1];
        if('+-*/^'.contains(last)){
          _expression = _expression.substring(0, _expression.length-1) + operator;
        } else {
          _expression += operator;
        }
    });
  }



  void _percentagePressed() {
    setState(() {
      try {
        double current = double.parse(_expression);
        current = current / 100;
        _expression = current
            .toStringAsFixed(6)
            .replaceAll(RegExp(r'\.?0+$'), '');
      } catch (e) {
        _expression = 'Error';
      }

    });
  }

  void _calculate() {
    setState(() {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);
          _expression = result.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
        } catch (e) {
          _expression = 'Error';
        }
    });
  }

  void _backspace() {
    setState(() {
      if (_expression.length > 1) {
        _expression = _expression.substring(0, _expression.length - 1);
      } else {
        _expression = "0";
      }
    });
  }

  void _clear() {
    setState(() {
      _expression = '0';
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
                    _expression,
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
                    _buildButton('X', () => _onOperatorPressed('*'), color: Colors.deepOrange),
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