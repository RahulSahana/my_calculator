import 'package:flutter/material.dart';
import 'package:my_calculator/pages/finance/currency.dart';
import 'package:my_calculator/pages/finance/emi.dart';

class Finance extends StatelessWidget {
  const Finance({super.key});

  @override
  Widget build(BuildContext context) {
    return const FinancePage();
  }
}

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final List<Map<String, dynamic>> items = [
    {"icon": Icons.currency_exchange, "label": "Currency"},
    {"icon": Icons.calculate_outlined, "label": "EMI"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.purple[100],
                  heroTag: null, // Optimization: Avoid hero lag
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => index == 0 
                          ? const CurrencyConverter() 
                          : const EmiCalculator(),
                      ),
                    );
                  },
                  child: Icon(
                    items[index]["icon"],
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  items[index]["label"],
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
