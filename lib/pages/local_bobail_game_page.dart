import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/local_board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_rendering/board.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/bobail_game_tutorial.dart';
import 'package:bobail_mobile/ui_interface/settings/board_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocalBobailGamePage extends HookConsumerWidget {
  const LocalBobailGamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final showTutorial = useState(true);
    final viewSettings = ref.watch(boardSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bobail'),
        elevation: 1,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          const Text('How to play'),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showTutorial.value = true;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(child: Board(controller: localBoardControllerProvider)),
          if (showTutorial.value)
            BobailTutorial(
              onClose: () {
                showTutorial.value = false;
              },
            ),
        ],
      ),
      floatingActionButton:
          showTutorial.value
              ? null
              : FloatingActionButton.extended(
                onPressed: () {
                  ref
                      .read(boardSettingsProvider.notifier)
                      .toggleReversedBoard();
                },
                icon: const Icon(Icons.sync_alt),
                label: Text(
                  !viewSettings.reversedBoard
                      ? 'White is facing Black'
                      : 'Passing the phone',
                ),
              ),
    );
  }
}
