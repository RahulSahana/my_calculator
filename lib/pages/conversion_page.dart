import 'package:flutter/material.dart';
import 'package:my_calculator/main.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        "Conversion Page",
        style: TextStyle(fontSize: 24),
      ),
    );
  }

}