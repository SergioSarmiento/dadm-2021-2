enum Symbol {
  x,
  o,
  blank,
}

class TicTacToeGame {
  TicTacToeGame({
    required this.player1,
    required this.player2,
  });
  final String player1;
  final String player2;
  final List<Symbol> cells = List.generate(9, (index) => Symbol.blank);

  void markACell(int index, Symbol symbol) {
    if (cells[index] == Symbol.blank) {
      cells[index] = symbol;
    }
  }

  List<int> getWinSet() {
    for (int i = 0; i <= 6; i += 3) {
      if (cells[i] != Symbol.blank &&
          cells[i] == cells[i + 1] &&
          cells[i + 1] == cells[i + 2]) {
        return [i, i + 1, i + 2];
      }
    }

    for (int i = 0; i <= 2; i++) {
      if (cells[i] != Symbol.blank &&
          cells[i] == cells[i + 3] &&
          cells[i + 3] == cells[i + 6]) {
        return [i, i + 3, i + 6];
      }
    }
    if (cells[0] != Symbol.blank &&
        cells[0] == cells[4] &&
        cells[4] == cells[8]) {
      return [0, 4, 8];
    }
    if (cells[2] != Symbol.blank &&
        cells[2] == cells[4] &&
        cells[4] == cells[6]) {
      return [2, 4, 6];
    }
    return [];
  }

  bool fullBoard() {
    return !cells.contains(Symbol.blank);
  }

  void resetBoard() {
    cells.asMap().forEach((key, value) => cells[key] = Symbol.blank);
  }
}
