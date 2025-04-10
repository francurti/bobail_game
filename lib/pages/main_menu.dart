import 'package:bobail_mobile/pages/bobail_game_page.dart';
import 'package:bobail_mobile/ui_interface/util/mini_board.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BOBAIL',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 32),

            MiniBoard(),
            const SizedBox(height: 32),

            PlayButton(),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => const BobailGamePage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: const Text('Play'),
    );
  }
}
