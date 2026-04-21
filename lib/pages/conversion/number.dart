import 'package:flutter/material.dart';

class Number extends StatefulWidget {
  const Number({super.key});

  @override
  State<Number> createState() => _NumberState();
}

class _NumberState extends State<Number> {
  String _input = "0";
  String _fromUnit = "Decimal";
  String _toUnit = "Binary";

  final List<String> _units = ["Decimal", "Binary", "Octal", "Hex"];

  // Cache Regexes to avoid recompiling them on every build/input
  static final RegExp _decimalRegex = RegExp(r'[0-9]');
  static final RegExp _binaryRegex = RegExp(r'[0-1]');
  static final RegExp _octalRegex = RegExp(r'[0-7]');
  static final RegExp _hexRegex = RegExp(r'[0-9A-Fa-f]');

  void _handleInput(String text) {
    setState(() {
      if (text == "AC") {
        _input = "0";
      } else if (text == "⌫") {
        if (_input.length > 1) {
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = "0";
        }
      } else {
        bool isValid = false;
        if (_fromUnit == "Decimal") isValid = _decimalRegex.hasMatch(text);
        else if (_fromUnit == "Binary") isValid = _binaryRegex.hasMatch(text);
        else if (_fromUnit == "Octal") isValid = _octalRegex.hasMatch(text);
        else if (_fromUnit == "Hex") isValid = _hexRegex.hasMatch(text);

        if (isValid) {
          if (_input == "0") _input = text;
          else if (_input.length < 15) _input += text;
        }
      }
    });
  }

  String _convert(String value, String from, String to) {
    try {
      int decimal;
      if (from == "Decimal") decimal = int.parse(value);
      else if (from == "Binary") decimal = int.parse(value, radix: 2);
      else if (from == "Octal") decimal = int.parse(value, radix: 8);
      else decimal = int.parse(value, radix: 16);

      if (to == "Decimal") return decimal.toString();
      if (to == "Binary") return decimal.toRadixString(2);
      if (to == "Octal") return decimal.toRadixString(8);
      return decimal.toRadixString(16).toUpperCase();
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _displaySection(),
            Divider(color: Colors.grey.shade800),
            _numpad(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back, color: Colors.purpleAccent), onPressed: () => Navigator.pop(context)),
          const Expanded(child: Center(child: Text("Number Base Converter", style: TextStyle(color: Colors.purpleAccent, fontSize: 22)))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _displaySection() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _unitRow(_fromUnit, _input, true),
            _unitRow(_toUnit, _convert(_input, _fromUnit, _toUnit), false),
          ],
        ),
      ),
    );
  }

  Widget _unitRow(String unit, String value, bool isInput) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: unit,
          dropdownColor: Colors.black,
          underline: const SizedBox(),
          iconEnabledColor: Colors.purpleAccent,
          style: const TextStyle(color: Colors.purpleAccent, fontSize: 22),
          items: _units.map((String v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() {
            if (isInput) {
              _fromUnit = v!;
              _input = "0"; 
            } else {
              _toUnit = v!;
            }
          }),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: isInput ? Colors.purple.shade300 : Colors.purpleAccent.shade100, fontSize: 32, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numpad() {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _numRow(["D", "E", "F"]),
                  _numRow(["A", "B", "C"]),
                  _numRow(["7", "8", "9"]),
                  _numRow(["4", "5", "6"]),
                  _numRow(["1", "2", "3"]),
                  _numRow(["", "0", ""]),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(children: [_sideButton("AC"), const SizedBox(height: 10), _sideButton("⌫")])),
          ],
        ),
      ),
    );
  }

  Widget _numRow(List<String> nums) => Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: nums.map((n) => _numButton(n)).toList()));

  Widget _numButton(String text) {
    bool isEnabled = true;
    if (text.isNotEmpty) {
      if (_fromUnit == "Binary") isEnabled = _binaryRegex.hasMatch(text);
      else if (_fromUnit == "Octal") isEnabled = _octalRegex.hasMatch(text);
      else if (_fromUnit == "Decimal") isEnabled = _decimalRegex.hasMatch(text);
      else if (_fromUnit == "Hex") isEnabled = _hexRegex.hasMatch(text);
    }

    return Expanded(
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.3,
        child: InkWell(
          onTap: (text.isEmpty || !isEnabled) ? null : () => _handleInput(text),
          child: Center(child: Text(text, style: const TextStyle(color: Colors.purpleAccent, fontSize: 24))),
        ),
      ),
    );
  }

  Widget _sideButton(String text) => Expanded(child: InkWell(onTap: () => _handleInput(text), child: Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(30)), child: Center(child: Text(text, style: const TextStyle(color: Colors.purpleAccent, fontSize: 20))))));
}
