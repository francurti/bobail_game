import 'package:bobail_mobile/pages/bobail_game_page.dart';
import 'package:bobail_mobile/ui_interface/util/mini_board.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Cream background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BOBAIL',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white, // a bit darker brown
              ),
            ),
            const SizedBox(height: 32),
            MiniBoard(),
            const SizedBox(height: 32),
            const PlayButton(),
            const SizedBox(height: 12),
            const PlayVsAIButton(),
            const SizedBox(height: 12),
            const PlaceholderButton(),
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
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, __) => const BobailGamePage(),
            transitionsBuilder: (_, animation, __, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              );
              return FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: const Text('Play locally'),
    );
  }
}

class PlayVsAIButton extends StatelessWidget {
  const PlayVsAIButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // You can add a specific route or AI setup later
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('AI mode coming soon!')));
      },
      child: const Text('Play vs AI (Coming Soon)'),
    );
  }
}

class PlaceholderButton extends StatelessWidget {
  const PlaceholderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Multiplayer coming soon!')),
        );
      },
      child: const Text('Multiplayer (Coming Soon)'),
    );
  }
}
