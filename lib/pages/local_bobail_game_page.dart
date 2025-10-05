import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/local_board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_rendering/board.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/bobail_game_tutorial.dart';
import 'package:bobail_mobile/ui_interface/settings/board_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocalBobailGamePage extends ConsumerStatefulWidget {
  const LocalBobailGamePage({super.key});

  @override
  ConsumerState<LocalBobailGamePage> createState() =>
      _LocalBobailGamePageState();
}

class _LocalBobailGamePageState extends ConsumerState<LocalBobailGamePage> {
  bool showTutorial = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              setState(() {
                showTutorial = true;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(child: Board(controller: LocalBoardController(viewSettings))),
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
      floatingActionButton:
          showTutorial
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
