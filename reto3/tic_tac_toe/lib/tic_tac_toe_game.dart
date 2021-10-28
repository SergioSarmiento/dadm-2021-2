import 'package:flutter/material.dart';

class TicTacToeGame {
  TicTacToeGame({
    required this.player1,
    required this.player2,
  });
  final String player1;
  final String player2;
  List<String> cells = ['', '', '', '', '', '', '', '', ''];
  List<String> symbols = ['X', 'O'];
  bool turn = false;

  void markCell(int index) {
    if (cells[index] == '') {
      turn = !turn;
      cells[index] = turn ? symbols[0] : symbols[1];
    }
  }

  void resetBoard() {
    cells = ['', '', '', '', '', '', '', '', ''];
  }
}

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final TicTacToeGame game =
      TicTacToeGame(player1: 'player1', player2: 'player2');

  void updateBoard(int index) {
    setState(() {
      game.markCell(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TicTacToeCell(
                value: game.cells[0],
                onPressed: () => updateBoard(0),
                right: true,
                bottom: true,
              ),
              TicTacToeCell(
                value: game.cells[1],
                onPressed: () => updateBoard(1),
                left: true,
                right: true,
                bottom: true,
              ),
              TicTacToeCell(
                value: game.cells[2],
                onPressed: () => updateBoard(2),
                left: true,
                bottom: true,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TicTacToeCell(
                value: game.cells[3],
                onPressed: () => updateBoard(3),
                top: true,
                right: true,
                bottom: true,
              ),
              TicTacToeCell(
                value: game.cells[4],
                onPressed: () => updateBoard(4),
                top: true,
                bottom: true,
                right: true,
                left: true,
              ),
              TicTacToeCell(
                value: game.cells[5],
                onPressed: () => updateBoard(5),
                top: true,
                left: true,
                bottom: true,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TicTacToeCell(
                value: game.cells[6],
                onPressed: () => updateBoard(6),
                top: true,
                right: true,
              ),
              TicTacToeCell(
                value: game.cells[7],
                onPressed: () => updateBoard(7),
                top: true,
                left: true,
                right: true,
              ),
              TicTacToeCell(
                value: game.cells[8],
                onPressed: () => updateBoard(8),
                top: true,
                left: true,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.restore),
        onPressed: () {
          setState(() {
            game.resetBoard();
          });
        },
      ),
    );
  }
}

class TicTacToeCell extends StatelessWidget {
  const TicTacToeCell({
    required this.value,
    required this.onPressed,
    this.top = false,
    this.right = false,
    this.left = false,
    this.bottom = false,
    this.size = 25.0,
  });

  final String value;
  final bool top;
  final bool right;
  final bool left;
  final bool bottom;
  final double size;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
            width: 3, color: top ? Colors.black : Colors.transparent),
        left: BorderSide(
            width: 3, color: left ? Colors.black : Colors.transparent),
        right: BorderSide(
            width: 3, color: right ? Colors.black : Colors.transparent),
        bottom: BorderSide(
            width: 3, color: bottom ? Colors.black : Colors.transparent),
      )),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: size * 2, fontStyle: FontStyle.italic),
        ),
        child: Text(
          value,
          style: TextStyle(color: value == 'X' ? Colors.red : Colors.blue),
        ),
      ),
    );
  }
}
