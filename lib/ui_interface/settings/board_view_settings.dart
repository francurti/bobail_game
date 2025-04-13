import 'package:flutter/material.dart';

class BoardViewSettings extends ChangeNotifier {
  bool _reversedBoard;

  BoardViewSettings({bool reversedBoard = false})
    : _reversedBoard = reversedBoard;

  factory BoardViewSettings.local({bool reversedBoard = false}) {
    return BoardViewSettings(reversedBoard: reversedBoard);
  }

  bool get isReversedView => _reversedBoard;

  set isReversedView(bool newValue) {
    if (_reversedBoard != newValue) {
      _reversedBoard = newValue;
      notifyListeners();
    }
  }

  void flip() {
    isReversedView = !isReversedView; // uses the safe setter
    notifyListeners();
  }
}
