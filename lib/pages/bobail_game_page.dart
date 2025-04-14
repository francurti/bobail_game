import 'package:bobail_mobile/ui_interface/bobail_game/board.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/bobail_game_tutorial.dart';
import 'package:bobail_mobile/ui_interface/settings/board_view_settings.dart';
import 'package:flutter/material.dart';

class BobailGamePage extends StatefulWidget {
  const BobailGamePage({super.key});

  @override
  State<BobailGamePage> createState() => _BobailGamePageState();
}

class _BobailGamePageState extends State<BobailGamePage> {
  late final BoardViewSettings viewSettings;
  bool showTutorial = false;

  @override
  void initState() {
    super.initState();
    viewSettings = BoardViewSettings.local(reversedBoard: false);
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
          Center(child: Board(viewSettings: viewSettings)),
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
                    viewSettings.flip();
                  });
                },
                icon: const Icon(Icons.sync_alt),
                label: Text(
                  !viewSettings.isReversedView
                      ? 'Fixed Board View'
                      : 'Follow Player Turn',
                ),
              ),
    );
  }
}
