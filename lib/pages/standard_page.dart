import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:my_calculator/main.dart';
import 'package:my_calculator/pages/conversion_page.dart';
import 'package:my_calculator/pages/finance_page.dart';

class HistoryItem {
  final String expression;
  final String answer;

  const HistoryItem(this.expression, this.answer);
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyCalculatorPage();
  }
}

class MyCalculatorPage extends StatefulWidget {
  const MyCalculatorPage({super.key});

  @override
  State<MyCalculatorPage> createState() => _MyCalculatorPageState();
}

class _MyCalculatorPageState extends State<MyCalculatorPage> {
  int _selectMode = 0;
  String _expression = '0';
  String _answer = '0';
  bool _justEvaluated = false;
  String _perExpression = '';
  bool _isPercentage = false;
  bool _isAdvanced = false;
  int _openBrackets = 0;

  final List<HistoryItem> _history = [];

  void _onDigitPressed(String digit) {
    setState(() {
      if (_justEvaluated) {
        _expression = '0';
        _answer = '0';
        _justEvaluated = false;
      }
      if (_expression == 'Error' ||
          _expression == 'Infinity' ||
          _expression == 'NaN')
        _expression = '0';
      if (_expression == '0') {
        _expression = digit;
      } else {
        _expression += digit;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (_justEvaluated) {
        _expression = _answer;
        _justEvaluated = false;
      }
      if (_expression.isEmpty) return;
      if (_expression == 'Error' ||
          _expression == 'Infinity' ||
          _expression == 'NaN')
        _expression = '0';

      if (operator.endsWith('(')) {
        _openBrackets++;
      }

      String last = _expression[_expression.length - 1];
      if ('+-*/^'.contains(last) && !operator.endsWith('(')) {
        _expression = _expression.substring(0, _expression.length - 1) + operator;
      } else {
        if (_expression == '0' && operator.endsWith('(')) {
          _expression = operator;
        } else {
          _expression += operator;
        }
      }
    });
  }

  void _openBracket() {
    setState(() {
      if (_expression.isEmpty || _expression == '0') {
        _expression = '(';
      } else {
        String last = _expression[_expression.length - 1];

        if (RegExp(r'[0-9)eπ]').hasMatch(last)) {
          _expression += '*(';
        } else {
          _expression += '(';
        }
      }
      _openBrackets++;
    });
  }

  void _closeBracket() {
    setState(() {
      if (_openBrackets > 0) {
        String last = _expression.isEmpty
            ? ''
            : _expression[_expression.length - 1];
        if (!'+-*/^'.contains(last)) {
          _expression += ')';
          print("closed bracket.");
          _openBrackets--;
        }
      }
    });
  }

  String _prepareExpression() {
    String exp = _expression;

    exp = exp.replaceAll('π', '3.14159265');

    while (_openBrackets > 0) {
      exp += ')';
      _openBrackets--;
    }

    if (exp.isNotEmpty && '+-*/^('.contains(exp[exp.length - 1])) {
      exp = exp.substring(0, exp.length - 1);
    }

    return exp;
  }

  void _percentagePressed() {
    setState(() {
      try {
        _perExpression = "$_expression%";
        _isPercentage = true;
        int i = _expression.length - 1;
        while (i > 0) {
          String ch = _expression[i];
          if ('+-*/'.contains(ch)) {
            break;
          }
          i--;
        }

        if (i <= 0) return;

        String left = _expression.substring(0, i);
        String op = _expression[i];
        String right = _expression.substring(i + 1);

        double first = double.parse(left);
        double second = double.parse(right);
        double per = second / 100;

        String result = (first * per).toString();
        _expression = _expression.substring(0, i + 1) + result;
      } catch (e) {
        _answer = 'Error';
      }
    });
  }

  void _calculate() {
    setState(() {
      try {
        String finalExp = _prepareExpression();
        Parser p = Parser();
        Expression exp = p.parse(finalExp);
        ContextModel cm = ContextModel();
        double result = exp.evaluate(EvaluationType.REAL, cm);
        _answer = result.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
        if (_isPercentage) {
          _expression = _perExpression;
          _isPercentage = false;
        }
        _history.add(HistoryItem(_expression, _answer));
      } catch (e) {
        _answer = 'Error';
      }
      _justEvaluated = true;
    });
  }

  void _backspace() {
    setState(() {
      if (_expression.length > 1) {
        _expression = _expression.substring(0, _expression.length - 1);
        _justEvaluated = false;
      } else {
        _expression = "0";
      }
    });
  }

  void _clear() {
    setState(() {
      _expression = '0';
      _answer = '0';
      _openBrackets = 0;
      _justEvaluated = false;
    });
  }

  double _getFontSize(int length) {
    if (length < 10) return 40.0;
    if (length < 20) return 30.0;
    if (length < 30) return 20.0;
    return 15.0;
  }

  Widget _buildButton(String text, VoidCallback onPressed, {Color? color}) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color ?? Theme.of(context).colorScheme.primaryContainer,
    );
  }

  Widget _basicPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('AC', _clear, color: Colors.red),
            _buildButton(
              '/',
                  () => _onOperatorPressed('/'),
              color: Colors.deepOrange,
            ),
            _buildButton(
              'X',
                  () => _onOperatorPressed('*'),
              color: Colors.deepOrange,
            ),
            _buildButton(
              '-',
                  () => _onOperatorPressed('-'),
              color: Colors.deepOrange,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('7', () => _onDigitPressed('7')),
            _buildButton('8', () => _onDigitPressed('8')),
            _buildButton('9', () => _onDigitPressed('9')),
            _buildButton(
              '+',
                  () => _onOperatorPressed('+'),
              color: Colors.deepOrange,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('4', () => _onDigitPressed('4')),
            _buildButton('5', () => _onDigitPressed('5')),
            _buildButton('6', () => _onDigitPressed('6')),
            _buildButton('%', _percentagePressed, color: Colors.deepOrange),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('1', () => _onDigitPressed('1')),
            _buildButton('2', () => _onDigitPressed('2')),
            _buildButton('3', () => _onDigitPressed('3')),
            _buildButton('⌫', _backspace, color: Colors.blue),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(_isAdvanced ? '🔬' : '⌨️', () {
              setState(() {
                _isAdvanced = !_isAdvanced;
              });
            }, color: Colors.greenAccent),
            _buildButton('0', () => _onDigitPressed('0')),
            _buildButton('.', () => _onDigitPressed('.')),
            _buildButton('=', _calculate, color: Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _advancedPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('tan', () => _onOperatorPressed('tan(')),
            _buildButton('√', () => _onOperatorPressed('sqrt(')),
            _buildButton('^', () => _onOperatorPressed('^')),
            _buildButton('(', _openBracket),
            _buildButton(')', _closeBracket),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('cos', () => _onOperatorPressed('cos(')),
            _buildButton('AC', _clear, color: Colors.red),
            _buildButton(
              '/',
                  () => _onOperatorPressed('/'),
              color: Colors.deepOrange,
            ),
            _buildButton(
              'X',
                  () => _onOperatorPressed('*'),
              color: Colors.deepOrange,
            ),
            _buildButton(
              '-',
                  () => _onOperatorPressed('-'),
              color: Colors.deepOrange,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('sin', () => _onOperatorPressed('sin(')),
            _buildButton('7', () => _onDigitPressed('7')),
            _buildButton('8', () => _onDigitPressed('8')),
            _buildButton('9', () => _onDigitPressed('9')),
            _buildButton(
              '+',
                  () => _onOperatorPressed('+'),
              color: Colors.deepOrange,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('log', () => _onOperatorPressed('log(')),
            _buildButton('4', () => _onDigitPressed('4')),
            _buildButton('5', () => _onDigitPressed('5')),
            _buildButton('6', () => _onDigitPressed('6')),
            _buildButton('%', _percentagePressed, color: Colors.deepOrange),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('e', () => _onDigitPressed('2.7183')),
            _buildButton('1', () => _onDigitPressed('1')),
            _buildButton('2', () => _onDigitPressed('2')),
            _buildButton('3', () => _onDigitPressed('3')),
            _buildButton('⌫', _backspace, color: Colors.blue),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(_isAdvanced ? '🔬' : '⌨️', () {
              setState(() {
                _isAdvanced = !_isAdvanced;
              });
            }, color: Colors.greenAccent),
            _buildButton('π', () => _onDigitPressed('π')),
            _buildButton('0', () => _onDigitPressed('0')),
            _buildButton('.', () => _onDigitPressed('.')),
            _buildButton('=', _calculate, color: Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _calculatorBody(){
    return Column(
      children: [
        Expanded(
          // history
          child: ListView.builder(
            reverse: false,
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];

              return Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // expression
                    Text(
                      item.expression,
                      style: TextStyle(
                        fontSize: (item.expression.length < 20)
                            ? 25
                            : _getFontSize(item.expression.length),
                        fontWeight: FontWeight.bold,
                        color: Colors.black12,
                      ),
                    ),
                    // answer
                    Text(
                      "= ${item.answer}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              // expression
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  _expression,
                  style: TextStyle(
                    fontSize: _getFontSize(_expression.length),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8),
              // answer
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  "= $_answer",
                  style: TextStyle(
                    fontSize: _justEvaluated ? 48 : 20,
                    fontWeight: FontWeight.bold,
                    color: _justEvaluated
                        ? Colors.deepOrange
                        : Colors.orangeAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: _isAdvanced ? _advancedPad() : _basicPad(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBody() {
    switch(_selectMode) {
      case 0 : return _calculatorBody();
      case 1 : return const ConversionPage();
      case 2 : return const Finance();
      default : return _calculatorBody();
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        titleSpacing: 0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () { setState(() {_selectMode = 0;});}, icon: Icon(Icons.calculate)),
              IconButton(onPressed: () { setState(() {_selectMode = 1;});}, icon: Icon(Icons.swap_horiz)),
              IconButton(onPressed: () { setState(() {_selectMode = 2;});}, icon: Icon(Icons.account_balance)),
              IconButton(
                icon: Icon(Icons.delete_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Clear History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to clear the history?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _history.clear();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Clear",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
        ),
      ),
      body: _buildBody(),
    );
  }
}
