import 'dart:math';
import 'package:flutter/material.dart';

class EmiCalculator extends StatefulWidget {
  const EmiCalculator({super.key});

  @override
  State<EmiCalculator> createState() => _EmiCalculatorState();
}

class _EmiCalculatorState extends State<EmiCalculator> {
  String _loanAmount = "0";
  String _interestRate = "0";
  String _tenure = "0";
  int _activeIndex = 0; // 0: Amount, 1: Rate, 2: Tenure

  void _handleInput(String text) {
    setState(() {
      String current;
      if (_activeIndex == 0) current = _loanAmount;
      else if (_activeIndex == 1) current = _interestRate;
      else current = _tenure;

      if (text == "AC") {
        current = "0";
      } else if (text == "⌫") {
        if (current.length > 1) {
          current = current.substring(0, current.length - 1);
        } else {
          current = "0";
        }
      } else {
        if (current == "0" && text != ".") {
          current = text;
        } else {
          if (text == "." && current.contains(".")) return;
          if (current.length < 12) {
            current += text;
          }
        }
      }

      if (_activeIndex == 0) _loanAmount = current;
      else if (_activeIndex == 1) _interestRate = current;
      else _tenure = current;
    });
  }

  Map<String, double> _calculateEmi() {
    double p = double.tryParse(_loanAmount) ?? 0;
    double r = (double.tryParse(_interestRate) ?? 0) / 12 / 100;
    double n = (double.tryParse(_tenure) ?? 0) * 12;

    if (p == 0 || r == 0 || n == 0) return {"emi": 0, "total": 0, "interest": 0};

    double emi = (p * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
    double totalPayable = emi * n;
    double totalInterest = totalPayable - p;

    return {
      "emi": emi,
      "total": totalPayable,
      "interest": totalInterest,
    };
  }

  @override
  Widget build(BuildContext context) {
    var results = _calculateEmi();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _inputRow("Loan Amount", _loanAmount, "", _activeIndex == 0, () => setState(() => _activeIndex = 0)),
                    _inputRow("Interest Rate", _interestRate, "% p.a.", _activeIndex == 1, () => setState(() => _activeIndex = 1)),
                    _inputRow("Tenure", _tenure, "Years", _activeIndex == 2, () => setState(() => _activeIndex = 2)),
                    const Divider(color: Colors.white24),
                    _resultSection(results),
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
          const Expanded(child: Center(child: Text("EMI Calculator", style: TextStyle(color: Colors.purpleAccent, fontSize: 22)))),
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
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text(value + unit, style: TextStyle(color: isActive ? Colors.purpleAccent : Colors.grey, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _resultSection(Map<String, double> results) {
    return Column(
      children: [
        _resultRow("Monthly EMI", results['emi']!.toStringAsFixed(2)),
        const SizedBox(height: 10),
        _resultRow("Total Interest", results['interest']!.toStringAsFixed(2)),
        const SizedBox(height: 10),
        _resultRow("Total Payable", results['total']!.toStringAsFixed(2)),
      ],
    );
  }

  Widget _resultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        Text(value, style: const TextStyle(color: Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.bold)),
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
