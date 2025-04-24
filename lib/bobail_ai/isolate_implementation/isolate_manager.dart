import 'dart:async';
import 'dart:isolate';

import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';
import 'package:bobail_mobile/bobail_ai/isolate_implementation/isolate_worker.dart';

class IsolateManager {
  late SendPort _aiPort;
  final ReceivePort _fromAi = ReceivePort();
  Isolate? _isolate; // <-- Keep a reference to the isolate

  Future<void> start() async {
    final initPort = ReceivePort();

    _isolate = await Isolate.spawn(aiIsolateEntry, initPort.sendPort);
    _aiPort = await initPort.first as SendPort;
  }

  void advanceBoard(Movement lastMove) {
    _aiPort.send([
      'advance',
      lastMove.pieceFrom,
      lastMove.pieceTo,
      lastMove.bobailFrom,
      lastMove.bobailTo,
    ]);
  }

  Future<Movement> getBestMove(int depth) {
    final completer = Completer<Movement>();
    _fromAi.first.then((msg) {
      completer.complete(msg as Movement);
    });
    _aiPort.send(['best', depth, _fromAi.sendPort]);
    return completer.future;
  }

  void dispose() {
    _fromAi.close();
    _aiPort.send(['dispose']);
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  Future<void> restart() async {
    dispose();
    await start();
  }
}
