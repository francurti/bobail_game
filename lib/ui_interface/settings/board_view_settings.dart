import 'package:flutter/material.dart';

class BoardSettings extends ChangeNotifier {
  bool _reversedBoard;

  BoardSettings({bool reversedBoard = false}) : _reversedBoard = reversedBoard;

  factory BoardSettings.local({bool reversedBoard = false}) {
    return BoardSettings(reversedBoard: reversedBoard);
  }

  bool get isReversedView => _reversedBoard;

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
