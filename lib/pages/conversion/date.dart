import 'package:flutter/material.dart';

class Date extends StatefulWidget {
  const Date({super.key});

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.purpleAccent,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) _startDate = picked; else _endDate = picked;
      });
    }
  }

  Map<String, dynamic> _calculateDifference() {
    Duration diff = _endDate.difference(_startDate).abs();
    int days = diff.inDays;
    int weeks = days ~/ 7;
    int months = (days / 30.436).floor();
    int years = (days / 365.25).floor();

    return {
      "days": days,
      "weeks": weeks,
      "months": months,
      "years": years,
    };
  }

  @override
  Widget build(BuildContext context) {
    var diff = _calculateDifference();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _dateRow("From Date", _startDate, () => _selectDate(context, true)),
                    _dateRow("To Date", _endDate, () => _selectDate(context, false)),
                    const Divider(color: Colors.white24),
                    Column(
                      children: [
                        const Text("Difference", style: TextStyle(color: Colors.grey, fontSize: 18)),
                        Text("${diff['days']}", style: const TextStyle(color: Colors.purpleAccent, fontSize: 48, fontWeight: FontWeight.bold)),
                        const Text("Total Days", style: TextStyle(color: Colors.grey, fontSize: 18)),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: [
                            _subDiff("${diff['years']}", "Years"),
                            _subDiff("${diff['months']}", "Months"),
                            _subDiff("${diff['weeks']}", "Weeks"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
          const Expanded(child: Center(child: Text("Date Calculator", style: TextStyle(color: Colors.purpleAccent, fontSize: 22)))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _dateRow(String label, DateTime date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.purpleAccent))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${date.day}/${date.month}/${date.year}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const Icon(Icons.calendar_today, color: Colors.purpleAccent),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _subDiff(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}
