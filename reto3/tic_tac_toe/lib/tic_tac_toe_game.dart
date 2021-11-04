import 'dart:math';
import '../assets/constants.dart' as constants;

class TicTacToeGame {
  TicTacToeGame({
    required this.player1,
    this.player2 = constants.computerName,
  }):computerPlays = player2 == constants.computerName;
  final String player1;
  String player2;
  List<String> cells = List.generate(9, (index) => constants.blank);
  List<String> symbols = [constants.playerOneSymbol, constants.playerTwoSymbol];
  bool playerOneTurn = true;
  bool computerPlays;

  void markACell(int index) {
    if (cells[index] == constants.blank) {
      cells[index] = playerOneTurn ? symbols[0] : symbols[1];
      if(getWinSet().isEmpty && computerPlays){
        computerMove();
      }else{
        playerOneTurn = !playerOneTurn;
      }
    }
  }

  void computerMove(){
      final _random = Random();
      while(!fullBoard()){
        final index = _random.nextInt(cells.length);
        if(cells[index] == constants.blank){
          cells[index] = symbols[1];
          break;
        }
      } 
  }

  List<int> getWinSet() {
    for (int i = 0; i <= 6; i += 3) {
      if (cells[i] != constants.blank &&
          cells[i] == cells[i + 1] &&
          cells[i + 1] == cells[i + 2]) {
        return [i, i + 1, i + 2];
      }
    }

    for (int i = 0; i <= 2; i++) {
      if (cells[i] != constants.blank &&
          cells[i] == cells[i + 3] &&
          cells[i + 3] == cells[i + 6]) {
        return [i, i + 3, i + 6];
      }
    }
    if (cells[0] != constants.blank && cells[0] == cells[4] && cells[4] == cells[8]) {
      return [0, 4, 8];
    }
    if (cells[2] != constants.blank && cells[2] == cells[4] && cells[4] == cells[6]) {
      return [2, 4, 6];
    }
    return [];
  }

  bool fullBoard() {
    return !cells.contains('');
  }

  void resetBoard() {
    cells = List.generate(9, (index) => constants.blank);
    playerOneTurn = true;
  }
}

