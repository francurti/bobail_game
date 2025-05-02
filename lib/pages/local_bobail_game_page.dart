import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/local_board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_rendering/board.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/bobail_game_tutorial.dart';
import 'package:bobail_mobile/ui_interface/settings/board_view_settings.dart';
import 'package:flutter/material.dart';

class LocalBobailGamePage extends StatefulWidget {
  const LocalBobailGamePage({super.key});

  @override
  State<LocalBobailGamePage> createState() => _LocalBobailGamePageState();
}

class _LocalBobailGamePageState extends State<LocalBobailGamePage> {
  late final BoardSettings viewSettings;
  bool showTutorial = false;

  @override
  void initState() {
    super.initState();
    viewSettings = BoardSettings.local(reversedBoard: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  setState(() {
                    viewSettings.flipBoardView();
                  });
                },
                icon: const Icon(Icons.sync_alt),
                label: Text(
                  !viewSettings.isReversedView
                      ? 'White is facing Black'
                      : 'Passing the phone',
                ),
              ),
    );
  }
}
