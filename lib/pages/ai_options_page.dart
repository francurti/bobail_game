import 'package:bobail_mobile/pages/ai_bobail_game_page.dart';
import 'package:bobail_mobile/ui_interface/settings/board_settings_provider.dart';
import 'package:bobail_mobile/ui_interface/util/mini_board.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            _AiModeOption.white(),
            const SizedBox(height: 8),

            _AiModeOption.black(),
            const SizedBox(height: 8),

            _AiModeOption.random(),
          ],
        ),
      ),
    );
  }
}

class _AiModeOption extends ConsumerWidget {
  const _AiModeOption._(this._tag, this._color, this._isWhiteFn);

  final String _tag;
  final Color _color;
  final bool Function() _isWhiteFn;

  bool get isWhite => _isWhiteFn();

  // Factories
  factory _AiModeOption.white() =>
      _AiModeOption._('White', Colors.white, () => true);

  factory _AiModeOption.black() =>
      _AiModeOption._('Black', Colors.black, () => false);

  factory _AiModeOption.random() => _AiModeOption._(
    'Random',
    Colors.black45,
    () => DateTime.now().microsecondsSinceEpoch % 2 == 0,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      onTap:
          () => {
            ref.read(boardSettingsProvider.notifier).setWhitePlayer(isWhite),
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 600),
                pageBuilder: (_, animation, __) => AiBobailGamePage(),
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
                  color: _color,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 5),
              Text(_tag, style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
