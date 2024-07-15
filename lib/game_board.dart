import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/helper_methods.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // 2 d list representing chessboard

  late List<List<ChessPiece?>> board;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  //initialize the board

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    // pawn
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagePath: 'lib/assets/Chess_plt45.svg.png');

      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagePath: 'lib/assets/Chess_plt45.svg.png');
    }

    // rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'lib/assets/Chess_rlt45.svg.png');
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'lib/assets/Chess_rlt45.svg.png');
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'lib/assets/Chess_rlt45.svg.png');
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'lib/assets/Chess_rlt45.svg.png');

    // knights
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'lib/assets/Chess_nlt45.svg.png');
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'lib/assets/Chess_nlt45.svg.png');
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'lib/assets/Chess_nlt45.svg.png');
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'lib/assets/Chess_nlt45.svg.png');

    // bishopss
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'lib/assets/Chess_blt45.svg.png');
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'lib/assets/Chess_blt45.svg.png');
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'lib/assets/Chess_blt45.svg.png');
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'lib/assets/Chess_blt45.svg.png');

    // queens
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: 'lib/assets/Chess_qlt45.svg.png');
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: 'lib/assets/Chess_qlt45.svg.png');

    // kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: 'lib/assets/Chess_klt45.svg.png');
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: 'lib/assets/Chess_klt45.svg.png');

    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GridView.builder(
          itemCount: 8 * 8,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8),
          itemBuilder: (context, index) {
            //get row and col

            int row = index ~/ 8;
            int col = index % 8;

            return Square(
              isWhite: isWhite(index),
              piece: board[row][col],
            );
          }),
    );
  }
}
