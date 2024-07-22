import 'dart:ffi';

import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/helper_methods.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // 2 d list representing chessboard

  late List<List<ChessPiece?>> board;

  ChessPiece? selectedPiece;

  //THE row and column  index of selected piece

  int selectedCol = -1;
  int selectedRow = -1;

  // A list of valid moves for the currenty selected piece
  //each move is represented as a list with 2 elements
  List<List<int>> validMoves = [];

  //list of white piece that is taken
  List<ChessPiece> whiteTakenPieces = [];

  //list of black piece that is taken
  List<ChessPiece> blackTakenPieces = [];

  //initial position king
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

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
          imagePath: 'lib/assets/Chess_pdt45.svg.png');

      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagePath: 'lib/assets/Chess_pdt45.svg.png');
    }

    // rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'lib/assets/Chess_rdt45.svg.png');
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'lib/assets/Chess_rdt45.svg.png');
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'lib/assets/Chess_rdt45.svg.png');
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'lib/assets/Chess_rdt45.svg.png');

    // knights
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'lib/assets/Chess_ndt45.svg.png');
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'lib/assets/Chess_ndt45.svg.png');
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'lib/assets/Chess_ndt45.svg.png');
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'lib/assets/Chess_ndt45.svg.png');

    // bishopss
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'lib/assets/Chess_bdt45.svg.png');
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'lib/assets/Chess_bdt45.svg.png');
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'lib/assets/Chess_bdt45.svg.png');
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'lib/assets/Chess_bdt45.svg.png');

    // queens
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: 'lib/assets/Chess_qdt45.svg.png');
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: 'lib/assets/Chess_qdt45.svg.png');

    // kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: 'lib/assets/Chess_kdt45.svg.png');
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: 'lib/assets/Chess_kdt45.svg.png');

    board = newBoard;
  }

  //user selected a piece
  void pieceSelected(int row, int col) {
    //if user selected a piece
    setState(() {
      //no piece selectes
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      // can select other piece

      else if (board[row][col] != null &&
          board[row][col]!.isWhite == isWhiteTurn) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  // raw valid moves
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }
    // Different directions based on their color
    int direction = piece!.isWhite ? -1 : 1;
    switch (piece.type) {
      case ChessPieceType.pawn:
        // One square forward
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        // Two squares forward
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + direction][col] == null &&
              board[row + 2 * direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        // Pawn can capture diagonally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;

      case ChessPieceType.rook:
        // horizontal and vertical direction
        var directions = [
          [-1, 0], // Up
          [1, 0], // Down
          [0, -1], // Left
          [0, 1] // Right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.knight:
        // knight can move 2 steps in one direction and 1 step in another direction
        var knightMoves = [
          [-2, -1],
          [-2, 1],
          [2, -1],
          [2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2]
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;

      case ChessPieceType.bishop:
        // diagonal
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.queen:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.king:
        var kingMoves = [
          [-1, -1],
          [-1, 0],
          [-1, 1],
          [0, -1],
          [0, 1],
          [1, -1],
          [1, 0],
          [1, 1]
        ];
        for (var move in kingMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        //castle
        //castle
        if (!piece.isMoved && piece.isWhite) {
          if (row == 7 && col == 4) {
            if (board[7][7] != null &&
                board[7][7]!.type == ChessPieceType.rook &&
                board[7][7]!.isWhite &&
                !board[7][7]!.isMoved &&
                board[7][5] == null &&
                board[7][6] == null) {
              candidateMoves.add([7, 6]);
            }
            if (board[7][0] != null &&
                board[7][0]!.type == ChessPieceType.rook &&
                board[7][0]!.isWhite &&
                !board[7][0]!.isMoved &&
                board[7][1] == null &&
                board[7][2] == null &&
                board[7][3] == null) {
              candidateMoves.add([7, 2]);
            }
          }
        } else {
          if (row == 0 && col == 4) {
            if (board[0][7] != null &&
                board[0][7]!.type == ChessPieceType.rook &&
                !board[0][7]!.isWhite &&
                !board[0][7]!.isMoved &&
                board[0][5] == null &&
                board[0][6] == null) {
              candidateMoves.add([0, 6]);
            }
            if (board[0][0] != null &&
                board[0][0]!.type == ChessPieceType.rook &&
                !board[0][0]!.isWhite &&
                !board[0][0]!.isMoved &&
                board[0][1] == null &&
                board[0][2] == null &&
                board[0][3] == null) {
              candidateMoves.add([0, 2]);
            }
          }
        }

      default:
        break;
    }
    return candidateMoves;
  }

  //real valid move
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);
    if (checkSimulation) {
      for (var Move in candidateMoves) {
        int endRow = Move[0];
        int endCol = Move[1];
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(Move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

//  function to check if the position is inside the board
  bool isInBoard(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }

  // function to move piece
  void movePiece(int row, int col) {
    //if new spot has enemy
    if (board[row][col] != null) {
      var capturedPiece = board[row][col];
      if (capturedPiece!.isWhite) {
        whiteTakenPieces.add(capturedPiece);
      } else {
        blackTakenPieces.add(capturedPiece);
      }
    }

    //castle

    // Handle castling
    if (selectedPiece!.type == ChessPieceType.king &&
        (col - selectedCol).abs() == 2) {
      // Kingside castling
      if (col > selectedCol) {
        board[row][col - 1] = board[row][col + 1];
        board[row][col + 1] = null;
      }
      // Queenside castling
      else {
        board[row][col + 1] = board[row][col - 2];
        board[row][col - 2] = null;
      }
    }

    // Check if the piece being moved is a king
    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [row, col];
      } else {
        blackKingPosition = [row, col];
      }
    }

    //move thr piece and clear old spot

    board[row][col] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // Mark the piece as moved
    selectedPiece!.isMoved = true;

    //see king check position
    if (iskingCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
    });
    //check it its checkmate
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("CHECKMATE!!"),
                actions: [
                  //play again button
                  TextButton(
                      onPressed: resetGame, child: const Text("Play Again"))
                ],
              ));
    }
    //change turn
    isWhiteTurn = !isWhiteTurn;
  }

  // is king ckeck?
  bool iskingCheck(bool isWhiteKing) {
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //check king position
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  //turn
  bool isWhiteTurn = true;

  // simulate a future move if its safe
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    //save the current board state
    ChessPiece? originalDestionPiece = board[endRow][endCol];

    //if piece is king save its current position and update to new one

    List<int>? originalKingPosition; //save the current king position
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      //update king position

      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    //simulate the move

    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    //check if our own king is under attack

    bool kingInCheck = iskingCheck(piece.isWhite);

    //return board to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestionPiece;

    //if the piece was king , restore its original position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  //its checkmate
  bool isCheckMate(bool isWhiteking) {
    //if king is not  check its not check mate
    if (!iskingCheck(isWhiteking)) {
      return false;
    }

    // if there is at least one legal move
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteking) {
          continue;
        }
        List<List<int>> validMoves =
            calculateRealValidMoves(i, j, board[i][j], true);
        if (validMoves.isNotEmpty) {
          return false;
        }
      }
    }

    //if none of the above condition are  met
    return true;
  }

  //reset game
  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    selectedPiece = null;
    whiteTakenPieces = [];
    blackTakenPieces = [];
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    checkStatus = false;
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          //white piece that are taken
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: whiteTakenPieces.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whiteTakenPieces[index].imagePath,
                isWhite: true,
              ),
            ),
          ),
          Text(checkStatus ? "CHECK" : ""),

          //chess board iin the middle
          Expanded(
            flex: 3,
            child: GridView.builder(
                itemCount: 8 * 8,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  //get row and col

                  int row = index ~/ 8;
                  int col = index % 8;

                  //check if this square is selected
                  bool isSelected = selectedRow == row && selectedCol == col;

                  //check if thus square is valid move
                  bool isValidMove = false;
                  for (var position in validMoves) {
                    if (position[0] == row && position[1] == col) {
                      isValidMove = true;
                      break;
                    }
                  }

                  return Square(
                    isWhite: isWhite(index),
                    piece: board[row][col],
                    isSelected: isSelected,
                    isValidMoves: isValidMove,
                    onTap: () => pieceSelected(row, col),
                  );
                }),
          ),

          //black piece that are taken
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: blackTakenPieces.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackTakenPieces[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
