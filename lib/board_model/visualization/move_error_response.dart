enum MoveErrorResponse {
  wrongPiece('Wrong Piece selected'),
  noSuchPiece('No such piece on board'),
  invalidMovement('That movement is not valid'),
  invalidBobailMovement('That bobail movement is not valid');

  const MoveErrorResponse(this.message);

  final String message;
}

abstract class MoveResult {
  bool get isOk;
  MoveErrorResponse? get error;
}

class MoveSuccess extends MoveResult {
  @override
  get isOk => true;

  @override
  get error => null;
}

class MoveFailure extends MoveResult {
  @override
  final MoveErrorResponse error;

  MoveFailure(this.error);

  @override
  get isOk => false;
}
