import 'package:chess/components/piece.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isValidMoves;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMoves,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

//if selected square is green
    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValidMoves) {
      squareColor = Colors.green[200];
    } else {
      squareColor = isWhite ? forgroundColor : backgroundColor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        child: piece != null
            ? Image.asset(piece!.imagePath,
                color: piece!.isWhite ? Colors.white : Colors.black)
            : null,
      ),
    );
  }
}
