import 'package:bobail_mobile/ui_interface/bobail_game/board.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/ai_board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/bobail_game_tutorial.dart';
import 'package:bobail_mobile/ui_interface/settings/board_view_settings.dart';
import 'package:flutter/material.dart';

class AiBobailGamePage extends StatefulWidget {
  const AiBobailGamePage({super.key});

  @override
  State<AiBobailGamePage> createState() => _AiBobailGamePageState();
}

class _AiBobailGamePageState extends State<AiBobailGamePage> {
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
            child: Board(controller: AiBoardController(viewSettings, true)),
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
