import 'package:hooks_riverpod/hooks_riverpod.dart';

final boardSettingsProvider =
    NotifierProvider<BoardSettingsNotifier, BoardSettings>(
      BoardSettingsNotifier.new,
    );

class BoardSettings {
  bool reversedBoard;
  bool isWhitePlayer;

  BoardSettings({this.reversedBoard = false, this.isWhitePlayer = true});

  BoardSettings copyWith({bool? reversedBoard, bool? isWhitePlayer}) {
    return BoardSettings(
      reversedBoard: reversedBoard ?? this.reversedBoard,
      isWhitePlayer: isWhitePlayer ?? this.isWhitePlayer,
    );
  }
}

class BoardSettingsNotifier extends Notifier<BoardSettings> {
  @override
  BoardSettings build() {
    return BoardSettings();
  }

  void toggleReversedBoard() {
    state = state.copyWith(reversedBoard: !state.reversedBoard);
  }

  void setReversed(bool value) {
    state = state.copyWith(reversedBoard: value);
  }

  void setWhitePlayer(bool value) {
    state = state.copyWith(isWhitePlayer: value);
  }
}
