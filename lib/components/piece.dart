enum ChessPieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final String imagePath;
  bool isMoved;

  ChessPiece({
    required this.type,
    required this.isWhite,
    required this.imagePath,
    this.isMoved = false,
  });
}
