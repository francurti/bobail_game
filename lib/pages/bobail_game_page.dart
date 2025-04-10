import 'package:bobail_mobile/ui_interface/bobail_game/board.dart';
import 'package:flutter/material.dart';

class BobailGamePage extends StatelessWidget {
  const BobailGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bobail'),
        elevation: 1,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: const Center(child: Board()),
      backgroundColor: Colors.orange,
    );
  }
}
