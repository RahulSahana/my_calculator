import 'package:flutter/material.dart';

class Bmi extends StatefulWidget {
  const Bmi({super.key});

  @override
  State<Bmi> createState() => _BmiState();
}

class _BmiState extends State<Bmi> {
  String _weightInput = "0";
  String _heightInput = "0";
  bool _isWeightActive = true;

  void _handleInput(String text) {
    setState(() {
      String current = _isWeightActive ? _weightInput : _heightInput;
      if (text == "AC") {
        if (_isWeightActive) _weightInput = "0"; else _heightInput = "0";
      } else if (text == "⌫") {
        if (current.length > 1) {
          current = current.substring(0, current.length - 1);
        } else {
          current = "0";
        }
        if (_isWeightActive) _weightInput = current; else _heightInput = current;
      } else {
        if (current == "0" && text != ".") {
          current = text;
        } else {
          if (text == "." && current.contains(".")) return;
          if (current.length < 10) {
            current += text;
          }
        }
        if (_isWeightActive) _weightInput = current; else _heightInput = current;
      }
    });
  }

  String _calculateBmi() {
    double weight = double.tryParse(_weightInput) ?? 0;
    double height = double.tryParse(_heightInput) ?? 0;
    if (height == 0) return "0.0";
    double heightInMeters = height / 100;
    double bmi = weight / (heightInMeters * heightInMeters);
    return bmi.toStringAsFixed(1);
  }

  String _getBmiCategory(String bmiStr) {
    double bmi = double.tryParse(bmiStr) ?? 0;
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese\nYou Should Die ☠️";
  }

  @override
  Widget build(BuildContext context) {
    String bmiResult = _calculateBmi();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _inputRow("Weight", _weightInput, "kg", _isWeightActive, () => setState(() => _isWeightActive = true)),
                    _inputRow("Height", _heightInput, "cm", !_isWeightActive, () => setState(() => _isWeightActive = false)),
                    const Divider(color: Colors.white24),
                    Column(
                      children: [
                        Text(bmiResult, style: const TextStyle(color: Colors.purpleAccent, fontSize: 48, fontWeight: FontWeight.bold)),
                        Text(_getBmiCategory(bmiResult), style: const TextStyle(color: Colors.grey, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
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
          IconButton(icon: const Icon(Icons.arrow_back, color: Colors.purpleAccent), onPressed: () => Navigator.pop(context)),
          const Expanded(child: Center(child: Text("BMI Calculator", style: TextStyle(color: Colors.purpleAccent, fontSize: 22)))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _inputRow(String label, String value, String unit, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white12 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 20)),
            Row(
              children: [
                Text(value, style: TextStyle(color: isActive ? Colors.purpleAccent : Colors.grey, fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
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
