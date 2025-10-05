import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/ai_board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_rendering/board.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/bobail_game_tutorial.dart';
import 'package:bobail_mobile/ui_interface/settings/board_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AiBobailGamePage extends ConsumerStatefulWidget {
  const AiBobailGamePage({super.key, required this.isWhitePlayer});

  final bool isWhitePlayer;

  @override
  ConsumerState<AiBobailGamePage> createState() => _AiBobailGamePageState();
}

class _AiBobailGamePageState extends ConsumerState<AiBobailGamePage> {
  bool showTutorial = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewSettings = ref.watch(boardSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bobail vs Ai'),
        elevation: 1,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          const Text('How to play'),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              setState(() {
                showTutorial = true;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Board(
              controller: AiBoardController(
                viewSettings,
                viewSettings.isWhitePlayer,
              ),
            ),
          ),
          if (showTutorial)
            BobailTutorial(
              onClose: () {
                setState(() {
                  showTutorial = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
