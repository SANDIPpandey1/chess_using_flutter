import 'package:chess/components/piece.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

//if selected square is green
    if (isSelected) {
      squareColor = Colors.blue;
    } else {
      squareColor = isWhite ? forgroundColor : backgroundColor;
    }
    return Container(
      color: isWhite ? forgroundColor : backgroundColor,
      child: piece != null
          ? Image.asset(piece!.imagePath,
              color: piece!.isWhite ? Colors.white : Colors.black)
          : null,
    );
  }
}
