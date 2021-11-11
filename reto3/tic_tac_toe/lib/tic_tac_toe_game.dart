import 'dart:math';
import '../assets/constants.dart' as constants;

enum Difficulty {
  easy,
  medium,
  hard,
}

class TicTacToeGame {
  TicTacToeGame({
    required this.player1,
    this.player2 = constants.computerName,
    this.difficulty = Difficulty.easy,
  }) : computerPlays = player2 == constants.computerName;
  final String player1;
  String player2;
  List<String> cells = List.generate(9, (index) => constants.blank);
  List<String> symbols = [constants.playerOneSymbol, constants.playerTwoSymbol];
  bool playerOneTurn = true;
  bool computerPlays;
  Difficulty difficulty;

  void markACell(int index) {
    if (cells[index] == constants.blank) {
      cells[index] = playerOneTurn ? symbols[0] : symbols[1];
      if (getWinSet().isEmpty && computerPlays) {
        computerMove();
      } else {
        playerOneTurn = !playerOneTurn;
      }
    }
  }

  void computerMove() {
    int move = -1;
    if (difficulty == Difficulty.easy) {
      move = _getRandomMove();
    } else if (difficulty == Difficulty.medium) {
      move = _getWinningMove(1);
      if (move == -1) {
        move = _getRandomMove();
      }
    } else if (difficulty == Difficulty.hard) {
      move = _getWinningMove(1);
      if (move == -1) {
        move = _getWinningMove(0);
        if (move == -1) {
          move = _getRandomMove();
        }
      }
    }
    if (move != -1) {
      cells[move] = symbols[1];
    }
  }

  int _getRandomMove() {
    final _random = Random();
    List availableCells = [];
    cells.asMap().forEach((key, value) {
      if (value == constants.blank) {
        availableCells.add(key);
      }
    });
    return availableCells.isNotEmpty
        ? availableCells[_random.nextInt(availableCells.length)]
        : -1;
  }

  int _getWinningMove(int player) {
    List markedCells = [];
    int ans = -1;
    cells.asMap().forEach((key, value) {
      if (value == symbols[player]) {
        markedCells.add(key);
      }
    });
    if (markedCells.length < 2) {
      return ans;
    } else {
      for (int i = 0; i < markedCells.length - 1 && ans == -1; i++) {
        final int row = markedCells[i] ~/ 3;
        final int column = markedCells[i] % 3;
        int temp = -1;
        for (int j = i + 1; j < markedCells.length && ans == -1; j++) {
          if (markedCells[j] ~/ 3 == row) {
            if (markedCells[j] - markedCells[i] > 1) {
              temp = markedCells[i] + 1;
              if (temp >= 0 && temp <= 8 && cells[temp] == constants.blank) {
                return temp;
              }
            } else {
              if ((markedCells[j] + 1) ~/ 3 == row) {
                temp = markedCells[j] + 1;
                if (temp >= 0 && temp <= 8 && cells[temp] == constants.blank) {
                  return temp;
                }
              }
              if ((markedCells[j] - 1) ~/ 3 == row) {
                temp = markedCells[i] - 1;
                if (temp >= 0 && temp <= 8 && cells[temp] == constants.blank) {
                  return temp;
                }
              }
            }
          } else {
            if (markedCells[j] % 3 == column) {
              if (markedCells[j] - markedCells[i] > 3) {
                temp = markedCells[i] + 3;
                if (temp >= 0 && temp <= 8 && cells[temp] == constants.blank) {
                  return temp;
                }
              } else {
                if ((markedCells[j] + 3) % 3 == column) {
                  temp = markedCells[j] + 3;
                  if (temp >= 0 &&
                      temp <= 8 &&
                      cells[temp] == constants.blank) {
                    return temp;
                  }
                }
                if ((markedCells[j] - 3) % 3 == column) {
                  temp = markedCells[i] - 3;
                  if (temp >= 0 &&
                      temp <= 8 &&
                      cells[temp] == constants.blank) {
                    return temp;
                  }
                }
              }
            } else {
              if (markedCells[i] % 2 == 0 && markedCells[j] % 2 == 0) {
                if (markedCells[j] ~/ 3 - markedCells[i] ~/ 3 == 2) {
                  if (cells[4] == constants.blank) return 4;
                } else {
                  if (markedCells[j] - markedCells[i] == 4) {
                    if (markedCells[i] == 0) {
                      if (cells[8] == constants.blank) return 8;
                    } else {
                      if (cells[0] == constants.blank) return 0;
                    }
                  } else {
                    if (markedCells[i] == 2) {
                      if (cells[6] == constants.blank) return 6;
                    } else {
                      if (cells[2] == constants.blank) return 2;
                    }
                  }
                }
              }
            }
          }
        }
      }
      return ans;
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
    if (cells[0] != constants.blank &&
        cells[0] == cells[4] &&
        cells[4] == cells[8]) {
      return [0, 4, 8];
    }
    if (cells[2] != constants.blank &&
        cells[2] == cells[4] &&
        cells[4] == cells[6]) {
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

  void changeDifficulty(Difficulty diff) {
    difficulty = diff;
  }
}
