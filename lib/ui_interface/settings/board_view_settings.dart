import 'package:flutter/material.dart';

class BoardSettings extends ChangeNotifier {
  bool _reversedBoard;
  bool _isWhitePlayer;

  BoardSettings({bool reversedBoard = false, bool isWhitePlayer = true})
    : _reversedBoard = reversedBoard,
      _isWhitePlayer = isWhitePlayer;

  factory BoardSettings.local({bool reversedBoard = false}) {
    return BoardSettings(reversedBoard: reversedBoard);
  }

  factory BoardSettings.ai({required bool isWhitePlayer}) {
    return BoardSettings(
      isWhitePlayer: isWhitePlayer,
      reversedBoard: !isWhitePlayer,
    );
  }

  bool get isReversedView => _reversedBoard;
  bool get isWhitePlayer => _isWhitePlayer;

  set isReversedView(bool newValue) {
    if (_reversedBoard != newValue) {
      _reversedBoard = newValue;
      notifyListeners();
    }
  }

  void flipBoardView() {
    isReversedView = !isReversedView;
    notifyListeners();
  }
}
