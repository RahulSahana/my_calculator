import 'package:flutter/material.dart';

class Length extends StatefulWidget {
  const Length({super.key});

  @override
  State<Length> createState() => _LengthState();
}

class _LengthState extends State<Length> {
  String _input = "0";

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
      } else if (text.isNotEmpty) {
        if (_input == "0" && text != ".") {
          _input = text;
        } else {
          if (text == "." && _input.contains(".")) return;
          if (_input.length < 10) { // Limit length to prevent overflow
            _input += text;
          }
        }
      }
    });
  }

  String _convert(String value, String from, String to) {
    double val = double.tryParse(value) ?? 0;
    double result = 0;

    // Simple logic: 1 Meter = 100 Centimeters
    if (from == "m" && to == "cm") result = val * 100;
    else if (from == "cm" && to == "m") result = val / 100;
    else result = val;

    // Formatting: Remove trailing zeros for a cleaner look
    if (result == result.toInt()) return result.toInt().toString();
    return result.toStringAsFixed(4).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.purpleAccent),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Length converter",
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
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
            _unitRow("m", _input, "Meter", isInput: true),
            _unitRow("cm", _convert(_input, "m", "cm"), "Centimeter", isInput: false),
          ],
        ),
      ),
    );
  }

  Widget _unitRow(String unit, String value, String label, {required bool isInput}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(unit, style: const TextStyle(color: Colors.purpleAccent, fontSize: 22)),
            const Icon(Icons.arrow_drop_down, color: Colors.purpleAccent),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: isInput ? Colors.purple.shade300 : Colors.purpleAccent.shade100,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _numpad() {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _numRow(["7", "8", "9"]),
                  _numRow(["4", "5", "6"]),
                  _numRow(["1", "2", "3"]),
                  _numRow(["0", ".", ""]),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded( // Use Expanded to ensure buttons fill vertical space
              child: Column(
                children: [
                  _sideButton("AC"),
                  const SizedBox(height: 10),
                  _sideButton("⌫"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numRow(List<String> nums) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: nums.map((n) => _numButton(n)).toList(),
      ),
    );
  }

  Widget _numButton(String text) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: text.isEmpty ? null : () => _handleInput(text),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.purpleAccent, fontSize: 28),
          ),
        ),
      ),
    );
  }

  Widget _sideButton(String text) {
    return Expanded(
      child: InkWell(
        onTap: () => _handleInput(text),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.purpleAccent, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
}