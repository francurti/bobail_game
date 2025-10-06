import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/ai_board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_rendering/board.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/bobail_game_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AiBobailGamePage extends HookConsumerWidget {
  const AiBobailGamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final showTutorial = useState(false);

    final controller = ref.read(aiBoardControllerProvider.notifier);
    Future.microtask(() => controller.init());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              () => {
                ref.invalidate(aiBoardControllerProvider),
                Navigator.of(context).pop(),
              },
        ),
        title: const Text('Bobail vs Ai'),
        elevation: 1,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
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
          Center(child: Board(controller: aiBoardControllerProvider)),
          if (showTutorial.value)
            BobailTutorial(
              onClose: () {
                showTutorial.value = false;
              },
            ),
        ],
      ),
    );
  }
}
