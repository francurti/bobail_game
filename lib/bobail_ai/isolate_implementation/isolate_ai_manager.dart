import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';
import 'package:bobail_mobile/bobail_ai/isolate_implementation/isolate_worker.dart';

class IsolateAiManager {
  late SendPort _aiPort;
  ReceivePort? _fromAi;
  Isolate? _isolate;

  final Queue<Completer<Movement>> _pendingMoves = Queue();

  Future<void> start() async {
    final initPort = ReceivePort();

    _isolate = await Isolate.spawn(aiIsolateEntry, initPort.sendPort);
    _aiPort = await initPort.first as SendPort;

    _fromAi = ReceivePort();
    _fromAi!.listen((message) {
      if (message is Movement) {
        if (_pendingMoves.isNotEmpty) {
          _pendingMoves.removeFirst().complete(message);
        }
      }
    });
    initPort.close();
  }

  void advanceBoard(Movement lastMove) {
    _aiPort.send([
      'advance',
      lastMove.bobailFrom,
      lastMove.bobailTo,
      lastMove.pieceFrom,
      lastMove.pieceTo,
    ]);
  }

  Future<Movement> getBestMove(int depth) {
    if (_fromAi == null) {
      throw StateError(
        'Run of get bestMove without starting the isolate first',
      );
    }
    final completer = Completer<Movement>();
    _pendingMoves.add(completer);
    _aiPort.send(['best', depth, _fromAi!.sendPort]);
    return completer.future;
  }

  void _disposeAndRestart() {
    _fromAi?.close();
    _fromAi = null;
    try {
      _aiPort.send(['restart']);
    } catch (error) {
      throw StateError('Error disposing the element: $error');
    }
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _pendingMoves.clear();
  }

  Future<void> restart() async {
    _disposeAndRestart();
    await start();
  }
}
