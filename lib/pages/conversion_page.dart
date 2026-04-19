import 'package:flutter/material.dart';
import 'package:my_calculator/pages/conversion/export.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  final List<Map<String, dynamic>> items = [
    {"icon": Icons.cake_outlined, "label": "Age"},
    {"icon": Icons.open_in_full_outlined, "label": "Area"},
    {"icon": Icons.monitor_weight_outlined, "label": "BMI"},
    {"icon": Icons.storage_outlined, "label": "Data"},
    {"icon": Icons.calendar_month_outlined, "label": "Date"},
    {"icon": Icons.local_offer_outlined, "label": "Discount"},
    {"icon": Icons.straighten_outlined, "label": "Length"},
    {"icon": Icons.person_outlined, "label": "Mass"},
    {"icon": Icons.format_list_numbered_outlined, "label": "Number"},
    {"icon": Icons.speed_outlined, "label": "Speed"},
    {"icon": Icons.thermostat_outlined, "label": "Temperature"},
    {"icon": Icons.access_time_outlined, "label": "Time"},
    {"icon": Icons.inventory_2_outlined, "label": "Volume"},
  ];

  Widget pages(int index) {
    print(index);
    switch (index) {
      case 0 : return const Age();
      case 1 : return const Area();
      case 2 : return const Bmi();
      case 3 : return const Data();
      case 4 : return const Date();
      case 5 : return const Discount();
      case 6 : return const Length();
      case 7 : return const Mass();
      case 8 : return const Number();
      case 9 : return const Speed();
      case 10 : return const Temperature();
      case 11 : return const Time();
      case 12 : return const Volume();
      default : return const ConversionPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                heroTag: index,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => pages(index),
                    ),
                  );
                },
                child: Icon(items[index]["icon"],color: Colors.black,),
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
    );
  }
}