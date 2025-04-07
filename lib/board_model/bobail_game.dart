import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/pieces/ball.dart';
import 'package:bobail_mobile/board_model/pieces/bobail.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';

class BobailGame {
  static final int piecesPerPlayer = 5;
  static final int whiteInitialPiecePos = 0;
  static final int blackInitialPiecePos = 20;
  static final int middle = 12;

  final Board board = Board();
  int turnCounter = 0;
  bool isWhiteTurn = true;

  late final Bobail bobail;

  BobailGame() {
    bobail = Bobail(board);
    for (int i = 0; i < piecesPerPlayer; i++) {
      final int whitePosition = whiteInitialPiecePos + i;
      final int blackPosition = blackInitialPiecePos + i;
      board.addBlackPiece(Ball(board, blackPosition, PieceKind.black));
      board.addWhitePiece(Ball(board, whitePosition, PieceKind.white));
    }
  }

  // TODO make a better return object so that the frontend can get a reason to why this does not work.
  bool _validMovement(
    int oldBallPosition,
    int adjacentIndex,
    int? newBobailPosition,
  ) {
    if (!_isBobailMovementValid(newBobailPosition)) {
      return false;
    }

    var ballToMove = board.getPieceByPosition(oldBallPosition);
    if (ballToMove == null ||
        !_isPieceCorrectColor(ballToMove) ||
        !ballToMove.canMove(adjacentIndex)) {
      return false;
    }

    return true;
  }

  bool _isBobailMovementValid(int? newBobailPosition) {
    if (newBobailPosition == null && turnCounter == 0) {
      return true;
    } else if (newBobailPosition != null) {
      return bobail.canMove(newBobailPosition);
    }

    return false;
  }

  bool _isPieceCorrectColor(Piece piece) {
    return isWhiteTurn
        ? piece.pieceKind == PieceKind.white
        : piece.pieceKind == PieceKind.black;
  }

  void move(int oldBallPosition, int adjacentIndex, int? newBobailPosition) {
    if (_validMovement(oldBallPosition, adjacentIndex, newBobailPosition)) {
      var ball = board.getPieceByPosition(oldBallPosition)!;
      _executeMove(newBobailPosition, ball, adjacentIndex);
      _advanceToNextTurn();
    }
  }

  void _executeMove(int? newBobailPosition, Piece piece, int adjacentIndex) {
    if (newBobailPosition != null) {
      bobail.move(newBobailPosition);
    }
    piece.move(adjacentIndex);
  }

  void _advanceToNextTurn() {
    isWhiteTurn = !isWhiteTurn;
    turnCounter++;
  }

  bool isGameOver() {
    return (!bobail.isAbleToMove() || bobail.isInDefinitePosition());
  }
}
