import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/data/room_dao.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/tic_tac_toe_game.dart';
import '/src/core/constants.dart' as constants;

enum Difficulty {
  easy,
  medium,
  hard,
}

class GamePageCubit extends Cubit<GamePageState> {
  GamePageCubit(
      {required this.gameMode,
      required TicTacToeGame game,
      required GamePageState initialState,
      this.difficulty = Difficulty.hard,
      this.key = 'no-key'})
      : super(initialState);

  GameMode gameMode;
  Difficulty difficulty;
  Soundpool pool = Soundpool.fromOptions();
  final String key;
  final roomDao = RoomDao();
  late final StreamSubscription<DatabaseEvent> _stream;
  Symbol currSymbol = Symbol.x;

  Future<void> cellMarked(int index) async {
    if (state is MyTurnGamePageState && state.game.emptyCell(index)) {
      _playSoundButton(constants.buttonSoundPath);
      state.game.markACell(
        index,
        currSymbol,
      );
      currSymbol = currSymbol == Symbol.x ? Symbol.o : Symbol.x;
      if (_checkWin()) {
        if (gameMode == GameMode.online) {
          await roomDao.makeMove(index, key);
        }
        emit(GameOverGamePageState(
            game: state.game, winner: (state as MyTurnGamePageState).myName));
      } else if (state.game.fullBoard()) {
        if (gameMode == GameMode.online) {
          await roomDao.makeMove(index, key);
        }
        emit(GameOverGamePageState(game: state.game, winner: ''));
      } else {
        switch (gameMode) {
          case GameMode.singlePlayer:
            emit(WaitingGamePageState(
              game: state.game,
              playerInTurn: currSymbol == Symbol.x
                  ? state.game.player1
                  : state.game.player2,
            ));
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
            await roomDao.makeMove(index, key);
            emit(WaitingGamePageState(
              game: state.game,
              playerInTurn: currSymbol == Symbol.x
                  ? state.game.player1
                  : state.game.player2,
            ));
            break;
        }
      }
    }
  }

  void startListening() {
    try {
      _stream = roomDao.getInstance().child(key).onChildChanged.listen((event) {
        if (state is WaitingGamePageState) {
          final index = event.snapshot.value as int;
          state.game.markACell(index, currSymbol);
          currSymbol = currSymbol == Symbol.x ? Symbol.o : Symbol.x;
          if (_checkWin()) {
            emit(
              GameOverGamePageState(
                  game: state.game,
                  winner: (state as WaitingGamePageState).playerInTurn),
            );
            roomDao.deleteRoom(key);
          } else if (state.game.fullBoard()) {
            emit(GameOverGamePageState(game: state.game, winner: ''));
            roomDao.deleteRoom(key);
          } else {
            emit(MyTurnGamePageState(
              game: state.game,
              myName: currSymbol == Symbol.x
                  ? state.game.player1
                  : state.game.player2,
            ));
          }
          _stream.cancel();
        }
      });
    } catch (e) {
      _stream.resume();
    }
  }

  void stopListening() {
    _stream.pause();
  }

  void waitingForMove() async {
    if (gameMode == GameMode.online && state is WaitingGamePageState) {
      await Future.delayed(Duration(seconds: 1));
      startListening();
      return;
    }
  }

  void newGame() {
    if (state is! WaitingGamePageState && gameMode != GameMode.online) {
      state.game.resetBoard();
      currSymbol = Symbol.x;
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
      state.game.markACell(move, currSymbol);
      currSymbol = currSymbol == Symbol.x ? Symbol.o : Symbol.x;
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
