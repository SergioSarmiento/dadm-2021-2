import 'dart:math';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/tic_tac_toe_game.dart';
import '/src/core/constants.dart' as constants;

enum Difficulty {
  easy,
  medium,
  hard,
}

class GamePageCubit extends Cubit<GamePageState> {
  GamePageCubit({
    required this.gameMode,
    required TicTacToeGame game,
    this.difficulty = Difficulty.hard,
  }) : super(MyTurnGamePageState(
          game: game,
          myName: game.player1,
        ));

  GameMode gameMode;
  Difficulty difficulty;
  Soundpool pool = Soundpool.fromOptions();

  Future<void> cellMarked(int index) async {
    if (state is MyTurnGamePageState) {
      _playSoundButton(constants.buttonSoundPath);
      state.game.markACell(
          index,
          (state as MyTurnGamePageState).myName == state.game.player1
              ? Symbol.x
              : Symbol.o);
      if (_checkWin()) {
        emit(GameOverGamePageState(
            game: state.game, winner: (state as MyTurnGamePageState).myName));
      } else if (state.game.fullBoard()) {
        emit(GameOverGamePageState(game: state.game, winner: ''));
      } else {
        switch (gameMode) {
          case GameMode.singlePlayer:
            emit(WaitingGamePageState(state.game));
            await Future.delayed(const Duration(seconds: 1));
            _playSoundButton(constants.buttonSoundPath);
            _computerMove();
            if (_checkWin()) {
              emit(GameOverGamePageState(
                  game: state.game, winner: state.game.player2));
            } else if (state.game.fullBoard()) {
              emit(GameOverGamePageState(game: state.game, winner: ''));
            } else {
              emit(MyTurnGamePageState(
                game: state.game,
                myName: state.game.player1,
              ));
            }
            break;
          case GameMode.twoPlayers:
            emit(MyTurnGamePageState(
              game: state.game,
              myName:
                  (state as MyTurnGamePageState).myName == state.game.player1
                      ? state.game.player2
                      : state.game.player1,
            ));
            break;
          case GameMode.online:
            // TODO: Handle this case.
            break;
        }
      }
    }
  }

  void newGame() {
    if (state is! WaitingGamePageState) {
      state.game.resetBoard();
      emit(MyTurnGamePageState(game: state.game, myName: state.game.player1));
    }
  }

  void _playSoundButton(String path) async {
    int soundId = await rootBundle.load(path).then((ByteData soundData) {
      return pool.load(soundData);
    });
    await pool.play(soundId);
  }

  bool _checkWin() {
    return state.game.getWinSet().isNotEmpty;
  }

  void _computerMove() {
    int move = -1;
    if (difficulty == Difficulty.easy) {
      move = _getRandomMove();
    } else if (difficulty == Difficulty.medium) {
      move = _getWinningMove(Symbol.o);
      if (move == -1) {
        move = _getRandomMove();
      }
    } else if (difficulty == Difficulty.hard) {
      move = _getWinningMove(Symbol.o);
      if (move == -1) {
        move = _getWinningMove(Symbol.x);
        if (move == -1) {
          move = _getRandomMove();
        }
      }
    }
    if (move != -1) {
      state.game.markACell(move, Symbol.o);
    }
  }

  int _getRandomMove() {
    final _random = Random();
    List availableCells = [];
    state.game.cells.asMap().forEach((key, value) {
      if (value == Symbol.blank) {
        availableCells.add(key);
      }
    });
    return availableCells.isNotEmpty
        ? availableCells[_random.nextInt(availableCells.length)]
        : -1;
  }

  int _getWinningMove(Symbol symbol) {
    List markedCells = [];
    int ans = -1;
    state.game.cells.asMap().forEach((key, value) {
      if (value == symbol) {
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
              if (temp >= 0 &&
                  temp <= 8 &&
                  state.game.cells[temp] == Symbol.blank) {
                return temp;
              }
            } else {
              if ((markedCells[j] + 1) ~/ 3 == row) {
                temp = markedCells[j] + 1;
                if (temp >= 0 &&
                    temp <= 8 &&
                    state.game.cells[temp] == Symbol.blank) {
                  return temp;
                }
              }
              if ((markedCells[j] - 1) ~/ 3 == row) {
                temp = markedCells[i] - 1;
                if (temp >= 0 &&
                    temp <= 8 &&
                    state.game.cells[temp] == Symbol.blank) {
                  return temp;
                }
              }
            }
          } else {
            if (markedCells[j] % 3 == column) {
              if (markedCells[j] - markedCells[i] > 3) {
                temp = markedCells[i] + 3;
                if (temp >= 0 &&
                    temp <= 8 &&
                    state.game.cells[temp] == Symbol.blank) {
                  return temp;
                }
              } else {
                if ((markedCells[j] + 3) % 3 == column) {
                  temp = markedCells[j] + 3;
                  if (temp >= 0 &&
                      temp <= 8 &&
                      state.game.cells[temp] == Symbol.blank) {
                    return temp;
                  }
                }
                if ((markedCells[j] - 3) % 3 == column) {
                  temp = markedCells[i] - 3;
                  if (temp >= 0 &&
                      temp <= 8 &&
                      state.game.cells[temp] == Symbol.blank) {
                    return temp;
                  }
                }
              }
            } else {
              if (markedCells[i] % 2 == 0 && markedCells[j] % 2 == 0) {
                if (markedCells[j] ~/ 3 - markedCells[i] ~/ 3 == 2) {
                  if (state.game.cells[4] == Symbol.blank) return 4;
                } else {
                  if (markedCells[j] - markedCells[i] == 4) {
                    if (markedCells[i] == 0) {
                      if (state.game.cells[8] == Symbol.blank) return 8;
                    } else {
                      if (state.game.cells[0] == Symbol.blank) return 0;
                    }
                  } else {
                    if (markedCells[i] == 2) {
                      if (state.game.cells[6] == Symbol.blank) return 6;
                    } else {
                      if (state.game.cells[2] == Symbol.blank) return 2;
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
}
