import 'package:bobail_mobile/ui_interface/board.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BobailApp());
}

class BobailApp extends StatelessWidget {
  const BobailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bobail game',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bobail'),
          elevation: 1,
          backgroundColor: Colors.green,
        ),
        body: const Center(child: Board()),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
