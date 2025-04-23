class PositionInformation {
  bool isHighligthed;
  bool isBobailPreview;
  bool isSelected;
  bool isLastMoved;

  PositionInformation(
    this.isHighligthed,
    this.isBobailPreview,
    this.isSelected, {
    this.isLastMoved = false,
  });
}
