import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/tic_tac_toe_game.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final TicTacToeGame game =
      TicTacToeGame(player1: 'player');

  bool isThereWinner = false;
  List<int> win = [];

  void updateBoard(int index) {
    setState(() {
      game.markACell(index);
      win = game.getWinSet();
      isThereWinner = win.isNotEmpty;
    });
  }

  String _getPlayerInTurn() {
    return game.playerOneTurn ? game.player1 : game.player2;
  }

  String _getWinner() {
    if (isThereWinner) {
      return game.playerOneTurn ? game.player2 : game.player1;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !isThereWinner && game.fullBoard()
              ? const Text(
                  'Draw',
                  style: TextStyle(fontSize: 20.0),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isThereWinner ? 'Winner: ' : 'Turn: ',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      isThereWinner ? _getWinner() : _getPlayerInTurn(),
                      style: TextStyle(
                          fontSize: 20.0,
                          color: isThereWinner
                              ? _getWinner() == game.player1
                                  ? Colors.red
                                  : Colors.blue
                              : _getPlayerInTurn() == game.player1
                                  ? Colors.red
                                  : Colors.blue),
                    ),
                  ],
                ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TicTacToeCell(
                    value: game.cells[0],
                    onPressed: !isThereWinner ? () => updateBoard(0) : () {},
                    right: true,
                    bottom: true,
                    color: isThereWinner && win.contains(0)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                  TicTacToeCell(
                    value: game.cells[1],
                    onPressed: !isThereWinner ? () => updateBoard(1) : () {},
                    left: true,
                    right: true,
                    bottom: true,
                    color: isThereWinner && win.contains(1)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                  TicTacToeCell(
                    value: game.cells[2],
                    onPressed: !isThereWinner ? () => updateBoard(2) : () {},
                    left: true,
                    bottom: true,
                    color: isThereWinner && win.contains(2)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TicTacToeCell(
                    value: game.cells[3],
                    onPressed: !isThereWinner ? () => updateBoard(3) : () {},
                    top: true,
                    right: true,
                    bottom: true,
                    color: isThereWinner && win.contains(3)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                  TicTacToeCell(
                    value: game.cells[4],
                    onPressed: !isThereWinner ? () => updateBoard(4) : () {},
                    top: true,
                    bottom: true,
                    right: true,
                    left: true,
                    color: isThereWinner && win.contains(4)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                  TicTacToeCell(
                    value: game.cells[5],
                    onPressed: !isThereWinner ? () => updateBoard(5) : () {},
                    top: true,
                    left: true,
                    bottom: true,
                    color: isThereWinner && win.contains(5)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TicTacToeCell(
                    value: game.cells[6],
                    onPressed: !isThereWinner ? () => updateBoard(6) : () {},
                    top: true,
                    right: true,
                    color: isThereWinner && win.contains(6)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                  TicTacToeCell(
                    value: game.cells[7],
                    onPressed: !isThereWinner ? () => updateBoard(7) : () {},
                    top: true,
                    left: true,
                    right: true,
                    color: isThereWinner && win.contains(7)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                  TicTacToeCell(
                    value: game.cells[8],
                    onPressed: !isThereWinner ? () => updateBoard(8) : () {},
                    top: true,
                    left: true,
                    color: isThereWinner && win.contains(8)
                        ? Colors.amberAccent
                        : Colors.transparent,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.restore),
        onPressed: () {
          setState(() {
            game.resetBoard();
            win = [];
            isThereWinner = false;
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
    this.color = Colors.transparent,
  });

  final String value;
  final bool top;
  final bool right;
  final bool left;
  final bool bottom;
  final double size;
  final Function() onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size),
      decoration: BoxDecoration(
          color: color,
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
