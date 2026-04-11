import 'package:flutter/material.dart';

class Volume extends StatelessWidget {
  const Volume({super.key});

  @override
  Widget build(BuildContext context) {
    return const VolumePage();
  }
}

class VolumePage extends StatefulWidget {
  const VolumePage({super.key});

  @override
  State<VolumePage> createState() => _VolumeState();
}

class _VolumeState extends State<VolumePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volume"),
      ),
    );
  }
}