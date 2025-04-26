import 'package:bobail_mobile/pages/ai_bobail_game_page.dart';
import 'package:bobail_mobile/ui_interface/util/mini_board.dart';
import 'package:flutter/material.dart';

class AiOptionsPage extends StatelessWidget {
  const AiOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MiniBoard(),
            const SizedBox(height: 8),
            const _AiModeOption(_PlayType.white),
            const SizedBox(height: 8),

            const _AiModeOption(_PlayType.black),
            const SizedBox(height: 8),

            const _AiModeOption(_PlayType.random),
          ],
        ),
      ),
    );
  }
}

enum _PlayType {
  white('White', Colors.white, _alwaysTrue),
  black('Black', Colors.black, _alwaysFalse),
  random('Random', Colors.black45, _randomBool);

  const _PlayType(this.tag, this.color, this.isWhitefn);
  final String tag;
  final Color color;
  final bool Function() isWhitefn;

  bool get isWhite => isWhitefn();

  static bool _alwaysTrue() => true;
  static bool _alwaysFalse() => false;
  static bool _randomBool() => DateTime.now().microsecondsSinceEpoch % 2 == 0;
}

class _AiModeOption extends StatelessWidget {
  const _AiModeOption(this.player);
  final _PlayType player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap:
          () => {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 600),
                pageBuilder:
                    (_, animation, __) =>
                        AiBobailGamePage(isWhitePlayer: player.isWhite),
                transitionsBuilder: (_, animation, __, child) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  );
                  return FadeTransition(
                    opacity: curved,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.98,
                        end: 1.0,
                      ).animate(curved),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          },
      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: player.color,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 5),
              Text(player.tag, style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
