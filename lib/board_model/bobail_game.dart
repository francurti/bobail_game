import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/pieces/ball.dart';
import 'package:bobail_mobile/board_model/pieces/bobail.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';
import 'package:bobail_mobile/board_model/visualization/board_state.dart';
import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';

class _LastMoved {
  _LastMoved(this.bobail, this.pieceFrom, this.pieceTo);

  int? bobail;
  int? pieceFrom;
  int? pieceTo;
}

class BobailGame {
  static final int piecesPerPlayer = 5;
  static final int whiteInitialPiecePos = 0;
  static final int blackInitialPiecePos = 20;
  static final int middle = 12;
  static final _LastMoved _lastMoved = _LastMoved(null, null, null);

  get lastBobailMove => _lastMoved.bobail;
  get lastPieceMoveFrom => _lastMoved.pieceFrom;
  get lastPieceMoveTo => _lastMoved.pieceTo;

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

  MoveResult _validMovement(
    int oldBallPosition,
    int adjacentIndex,
    MoveResult bobailMoveResult,
  ) {
    if (!bobailMoveResult.isOk) {
      return bobailMoveResult;
    }

    var ballToMove = board.getPieceByPosition(oldBallPosition);
    if (ballToMove == null) {
      return MoveFailure(MoveErrorResponse.noSuchPiece);
    }

    if (!isMoveableThisTurn(ballToMove)) {
      return MoveFailure(MoveErrorResponse.wrongPiece);
    }

    if (!ballToMove.canMove(adjacentIndex)) {
      return MoveFailure(MoveErrorResponse.invalidMovement);
    }

    return MoveSuccess();
  }

  bool _isBobailMovementValid(int? newBobailPosition) {
    if (newBobailPosition == null && turnCounter == 0) {
      return true;
    } else if (newBobailPosition != null) {
      return bobail.canMove(newBobailPosition);
    }

    return false;
  }

  bool isMoveableThisTurn(Piece piece) {
    return isWhiteTurn
        ? piece.pieceKind == PieceKind.white
        : piece.pieceKind == PieceKind.black;
  }

  MoveResult move(
    int oldBallPosition,
    int adjacentIndex,
    int? newBobailPosition,
  ) {
    MoveResult bobailMove = _attemptBobailMovement(newBobailPosition);

    var moveCheck = _validMovement(oldBallPosition, adjacentIndex, bobailMove);
    if (!moveCheck.isOk) {
      bobail.undoMove();
      return moveCheck;
    }
    var ball = board.getPieceByPosition(oldBallPosition)!;
    var finalPiece = ball.move(adjacentIndex);
    _lastMoved.pieceTo = finalPiece;
    _lastMoved.pieceFrom = oldBallPosition;
    _advanceToNextTurn();

    return moveCheck;
  }

  MoveResult _attemptBobailMovement(int? newBobailPosition) {
    if (!_isBobailMovementValid(newBobailPosition)) {
      return MoveFailure(MoveErrorResponse.invalidBobailMovement);
    }
    if (newBobailPosition != null) {
      bobail.move(newBobailPosition);
      _lastMoved.bobail = newBobailPosition;
    }
    return MoveSuccess();
  }

  void _advanceToNextTurn() {
    isWhiteTurn = !isWhiteTurn;
    turnCounter++;
  }

  bool isGameOver() {
    return (!bobail.isAbleToMove() || bobail.isInDefinitePosition());
  }

  String getWinner() {
    if (!isGameOver()) {
      throw StateError('There\'s no winner yet');
    }
    if (!bobail.isAbleToMove()) {
      return isWhiteTurn ? 'Black' : 'White';
    }
    if (bobail.isInWhiteWinningPosition()) {
      return 'White';
    }
    if (bobail.isInBlackWinningPosition()) {
      return 'Black';
    }

    throw StateError('There\'s no winner yet');
  }

  BoardState showBoardState() {
    return BoardState(turnCounter, board.getVisualBoard(), isWhiteTurn);
  }
}
