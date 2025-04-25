import 'dart:isolate';

import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';
import 'package:bobail_mobile/bobail_ai/bobail_ai.dart';

void aiIsolateEntry(SendPort controlPort) {
  final port = ReceivePort();

  controlPort.send(port.sendPort);

  BobailAi ai = BobailAi.base();

  port.listen((msg) {
    final List data = msg;
    final cmd = data[0] as String;

    if (cmd == 'advance') {
      // ['advance', from, to, bobail, bobailTo]
      ai.trackingBoard.advance(Movement(data[1], data[2], data[3], data[4]));
    } else if (cmd == 'best') {
      if (ai.trackingBoard.isTerminalState()) {}
      // ['best', depth, replyPort ]
      final depth = data[1] as int;
      final SendPort reply = data[2] as SendPort;
      final move = ai.getBestMove(depth);

      reply.send(move);
    } else if (cmd == 'restart') {
      ai.dispose();
      ai = BobailAi.base();
    }
  });
}
