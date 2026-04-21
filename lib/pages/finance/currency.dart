import 'package:flutter/material.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String _input = "0";
  String _fromUnit = "USD";
  String _toUnit = "INR";

  final List<String> _units = [
    "INR",
    "USD",
    "JPY",
    "CNY",
    "EUR",
    "BDT",
    "NPR",
    "PKR",
    "BTN",
    "LKR"
  ];

  // Static conversion rates (Base: USD)
  final Map<String, double> _rates = {
    "USD": 1.0,
    "INR": 91.5,
    "JPY": 151.0,
    "CNY": 6.85,
    "EUR": 0.92,
    "BDT": 122.3,
    "NPR": 145.0,
    "PKR": 279.5,
    "BTN": 91.5,
    "LKR": 310.0,
  };

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
        if (_input == "0" && text != ".") {
          _input = text;
        } else {
          if (text == "." && _input.contains(".")) return;
          if (_input.length < 12) {
            _input += text;
          }
        }
      }
    });
  }

  String _convert(String value, String from, String to) {
    double val = double.tryParse(value) ?? 0;
    double inUSD = val / (_rates[from] ?? 1);
    double result = inUSD * (_rates[to] ?? 1);

    return result.toStringAsFixed(2);
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "* Using static rates for demonstration < April , 2026 >",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.purpleAccent),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Currency Converter",
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
          style: const TextStyle(color: Colors.purpleAccent, fontSize: 24),
          items: _units.map((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              if (isInput) _fromUnit = newValue!;
              else _toUnit = newValue!;
            });
          },
        ),
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
      ],
    );
  }

  Widget _numpad() {
    return Expanded(
      flex: 3,
      child: Padding(
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
            Expanded(
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
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white12,
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
}
