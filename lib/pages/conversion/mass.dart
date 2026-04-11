import 'package:flutter/material.dart';

class Mass extends StatefulWidget {
  const Mass({super.key});

  @override
  State<Mass> createState() => _MassState();
}

class _MassState extends State<Mass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mass"),
      ),
    );
  }
}