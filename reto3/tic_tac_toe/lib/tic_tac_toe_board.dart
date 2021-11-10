import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/tic_tac_toe_game.dart';
import '../assets/constants.dart' as constants;

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  int _selectedIndex = 0;
  final TicTacToeGame game = TicTacToeGame(player1: constants.playerName);

  bool isThereWinner = false;
  List<int> win = [];

  void updateBoard(int index) {
    setState(() {
      game.markACell(index);
      win = game.getWinSet();
      isThereWinner = win.isNotEmpty;
    });
  }

  void _newGame() {
    setState(() {
      game.resetBoard();
      win = [];
      isThereWinner = false;
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _difficultyColor() {
    switch (_selectedIndex) {
      case 0:
        {
          return constants.playerOneColor;
        }
      case 1:
        {
          return constants.borders;
        }
      default:
        {
          return constants.playerTwoColor;
        }
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
        title: const Text(constants.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
                        ? constants.winningSet
                        : constants.background,
                  ),
                  TicTacToeCell(
                    value: game.cells[1],
                    onPressed: !isThereWinner ? () => updateBoard(1) : () {},
                    left: true,
                    right: true,
                    bottom: true,
                    color: isThereWinner && win.contains(1)
                        ? constants.winningSet
                        : constants.background,
                  ),
                  TicTacToeCell(
                    value: game.cells[2],
                    onPressed: !isThereWinner ? () => updateBoard(2) : () {},
                    left: true,
                    bottom: true,
                    color: isThereWinner && win.contains(2)
                        ? constants.winningSet
                        : constants.background,
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
                        ? constants.winningSet
                        : constants.background,
                  ),
                  TicTacToeCell(
                    value: game.cells[4],
                    onPressed: !isThereWinner ? () => updateBoard(4) : () {},
                    top: true,
                    bottom: true,
                    right: true,
                    left: true,
                    color: isThereWinner && win.contains(4)
                        ? constants.winningSet
                        : constants.background,
                  ),
                  TicTacToeCell(
                    value: game.cells[5],
                    onPressed: !isThereWinner ? () => updateBoard(5) : () {},
                    top: true,
                    left: true,
                    bottom: true,
                    color: isThereWinner && win.contains(5)
                        ? constants.winningSet
                        : constants.background,
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
                        ? constants.winningSet
                        : constants.background,
                  ),
                  TicTacToeCell(
                    value: game.cells[7],
                    onPressed: !isThereWinner ? () => updateBoard(7) : () {},
                    top: true,
                    left: true,
                    right: true,
                    color: isThereWinner && win.contains(7)
                        ? constants.winningSet
                        : constants.background,
                  ),
                  TicTacToeCell(
                    value: game.cells[8],
                    onPressed: !isThereWinner ? () => updateBoard(8) : () {},
                    top: true,
                    left: true,
                    color: isThereWinner && win.contains(8)
                        ? constants.winningSet
                        : constants.background,
                  ),
                ],
              ),
            ],
          ),
          !isThereWinner && game.fullBoard()
              ? const Text(
                  constants.draw,
                  style: TextStyle(fontSize: constants.fontSize),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isThereWinner ? constants.winText : constants.turnText,
                      style: const TextStyle(fontSize: constants.fontSize),
                    ),
                    Text(
                      isThereWinner ? _getWinner() : _getPlayerInTurn(),
                      style: TextStyle(
                          fontSize: constants.fontSize,
                          color: isThereWinner
                              ? _getWinner() == game.player1
                                  ? constants.playerOneColor
                                  : constants.playerTwoColor
                              : _getPlayerInTurn() == game.player1
                                  ? constants.playerOneColor
                                  : constants.playerTwoColor),
                    ),
                  ],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _newGame,
                child: const Text('New Game'),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Quit'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: constants.difficultyEasy,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: constants.difficultyMedium,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood_bad),
            label: constants.difficultyHard,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _difficultyColor(),
        onTap: _onItemTapped,
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
    this.size = constants.cellSize,
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
                width: constants.borderWidth,
                color: top ? constants.borders : constants.background),
            left: BorderSide(
                width: constants.borderWidth,
                color: left ? constants.borders : constants.background),
            right: BorderSide(
                width: constants.borderWidth,
                color: right ? constants.borders : constants.background),
            bottom: BorderSide(
                width: constants.borderWidth,
                color: bottom ? constants.borders : constants.background),
          )),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: size * 3, fontStyle: FontStyle.italic),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: value == constants.playerOneSymbol
                ? constants.playerOneColor
                : constants.playerTwoColor,
          ),
        ),
      ),
    );
  }
}
