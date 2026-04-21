import 'package:flutter/material.dart';

class Age extends StatefulWidget {
  const Age({super.key});

  @override
  State<Age> createState() => _AgeState();
}

class _AgeState extends State<Age> {
  DateTime _birthDate = DateTime.now();
  DateTime _today = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthDate ? _birthDate : _today,
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
        if (isBirthDate) _birthDate = picked; else _today = picked;
      });
    }
  }

  Map<String, int> _calculateAge() {
    int years = _today.year - _birthDate.year;
    int months = _today.month - _birthDate.month;
    int days = _today.day - _birthDate.day;

    if (days < 0) {
      months--;
      days += DateTime(_today.year, _today.month, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    return {"years": years, "months": months, "days": days};
  }

  @override
  Widget build(BuildContext context) {
    var age = _calculateAge();
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
                    _dateRow("Date of Birth", _birthDate, () => _selectDate(context, true)),
                    _dateRow("Today's Date", _today, () => _selectDate(context, false)),
                    const Divider(color: Colors.white24),
                    Column(
                      children: [
                        Text("${age['years']}", style: const TextStyle(color: Colors.purpleAccent, fontSize: 64, fontWeight: FontWeight.bold)),
                        const Text("Years Old", style: TextStyle(color: Colors.grey, fontSize: 24)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _subAge("${age['months']}", "Months"),
                            const SizedBox(width: 40),
                            _subAge("${age['days']}", "Days"),
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
          const Expanded(child: Center(child: Text("Age Calculator", style: TextStyle(color: Colors.purpleAccent, fontSize: 22)))),
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

  Widget _subAge(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ],
    );
  }
}
