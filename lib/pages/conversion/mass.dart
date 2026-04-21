import 'package:flutter/material.dart';

class Mass extends StatefulWidget {
  const Mass({super.key});

  @override
  State<Mass> createState() => _MassState();
}

class _MassState extends State<Mass> {
  String _input = "0";
  String _fromUnit = "kg";
  String _toUnit = "g";

  final List<String> _units = ["kg", "g", "mg", "ton", "lb", "oz"];

  final Map<String, double> _conversionToGram = {
    "kg": 1000.0,
    "g": 1.0,
    "mg": 0.001,
    "ton": 1000000.0,
    "lb": 453.592,
    "oz": 28.3495,
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
          if (_input.length < 10) {
            _input += text;
          }
        }
      }
    });
  }

  String _convert(String value, String from, String to) {
    double val = double.tryParse(value) ?? 0;
    double inGrams = val * (_conversionToGram[from] ?? 1);
    double result = inGrams / (_conversionToGram[to] ?? 1);

    if (result == result.toInt()) return result.toInt().toString();
    return result
        .toStringAsFixed(6)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  String _getLabel(String unit) {
    switch (unit) {
      case "kg": return "Kilogram";
      case "g": return "Gram";
      case "mg": return "Milligram";
      case "ton": return "Metric Ton";
      case "lb": return "Pound";
      case "oz": return "Ounce";
      default: return unit;
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
          const Expanded(child: Center(child: Text("Mass Converter", style: TextStyle(color: Colors.purpleAccent, fontSize: 22)))),
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
          onChanged: (v) => setState(() => isInput ? _fromUnit = v! : _toUnit = v!),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(color: isInput ? Colors.purple.shade300 : Colors.purpleAccent.shade100, fontSize: 36, fontWeight: FontWeight.bold))),
            Text(_getLabel(unit), style: const TextStyle(color: Colors.grey)),
          ],
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
            Expanded(flex: 3, child: Column(children: [_numRow(["7", "8", "9"]), _numRow(["4", "5", "6"]), _numRow(["1", "2", "3"]), _numRow(["0", ".", ""])])),
            const SizedBox(width: 10),
            Expanded(child: Column(children: [_sideButton("AC"), const SizedBox(height: 10), _sideButton("⌫")])),
          ],
        ),
      ),
    );
  }

  Widget _numRow(List<String> nums) => Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: nums.map((n) => _numButton(n)).toList()));

  Widget _numButton(String text) => Expanded(child: InkWell(onTap: text.isEmpty ? null : () => _handleInput(text), child: Center(child: Text(text, style: const TextStyle(color: Colors.purpleAccent, fontSize: 28)))));

  Widget _sideButton(String text) => Expanded(child: InkWell(onTap: () => _handleInput(text), child: Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(30)), child: Center(child: Text(text, style: const TextStyle(color: Colors.purpleAccent, fontSize: 20))))));
}
