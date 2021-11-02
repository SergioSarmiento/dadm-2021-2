import 'dart:math';

const String computerName = 'computer';

class TicTacToeGame {
  TicTacToeGame({
    required this.player1,
    this.player2 = computerName,
  }):computerPlays = player2 == computerName;
  final String player1;
  String player2;
  List<String> cells = ['', '', '', '', '', '', '', '', ''];
  List<String> symbols = ['X', 'O'];
  bool playerOneTurn = true;
  bool computerPlays;

  void markACell(int index) {
    if (cells[index] == '') {
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
        if(cells[index] == ''){
          cells[index] = symbols[1];
          break;
        }
      } 
  }

  List<int> getWinSet() {
    for (int i = 0; i <= 6; i += 3) {
      if (cells[i] != '' &&
          cells[i] == cells[i + 1] &&
          cells[i + 1] == cells[i + 2]) {
        return [i, i + 1, i + 2];
      }
    }

    for (int i = 0; i <= 2; i++) {
      if (cells[i] != '' &&
          cells[i] == cells[i + 3] &&
          cells[i + 3] == cells[i + 6]) {
        return [i, i + 3, i + 6];
      }
    }
    if (cells[0] != '' && cells[0] == cells[4] && cells[4] == cells[8]) {
      return [0, 4, 8];
    }
    if (cells[2] != '' && cells[2] == cells[4] && cells[4] == cells[6]) {
      return [2, 4, 6];
    }
    return [];
  }

  bool fullBoard() {
    return !cells.contains('');
  }

  void resetBoard() {
    cells = ['', '', '', '', '', '', '', '', ''];
    playerOneTurn = true;
  }
}

