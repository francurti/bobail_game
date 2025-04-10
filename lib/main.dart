import 'package:bobail_mobile/pages/main_menu.dart';
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
      debugShowCheckedModeBanner: false,

      home: MainMenu(),
    );
  }
}
