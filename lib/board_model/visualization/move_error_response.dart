enum MoveErrorResponse {
  wrongPiece,
  noSuchPiece,
  invalidMovement,
  invalidBobailMovement,
}

abstract class MoveResult {
  get isOk;
  get error;
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
