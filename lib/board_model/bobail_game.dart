import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/pieces/ball.dart';
import 'package:bobail_mobile/board_model/pieces/bobail.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';
import 'package:bobail_mobile/board_model/visualization/board_state.dart';
import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';

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

  MoveResult _validMovement(
    int oldBallPosition,
    int adjacentIndex,
    int? newBobailPosition,
  ) {
    if (!_isBobailMovementValid(newBobailPosition)) {
      return MoveFailure(MoveErrorResponse.invalidBobailMovement);
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
    print(
      'from: ${oldBallPosition} to: ${adjacentIndex} bobail: ${newBobailPosition}',
    );

    var moveCheck = _validMovement(
      oldBallPosition,
      adjacentIndex,
      newBobailPosition,
    );

    if (moveCheck.isOk) {
      var ball = board.getPieceByPosition(oldBallPosition)!;
      _executeMove(newBobailPosition, ball, adjacentIndex);
      _advanceToNextTurn();
    }

    return moveCheck;
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

  BoardState showBoardState() {
    return BoardState(turnCounter, board.getVisualBoard(), isWhiteTurn);
  }
}
