import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/tic_tac_toe_game.dart';

enum GameMode {
  singlePlayer,
  twoPlayers,
  online,
}

abstract class GamePageState {
  GamePageState(this.game);
  final TicTacToeGame game;
}

class MyTurnGamePageState extends GamePageState {
  MyTurnGamePageState({required TicTacToeGame game, required this.myName})
      : super(game);
  final String myName;
}

class WaitingGamePageState extends GamePageState {
  final String playerInTurn;
  WaitingGamePageState({
    required TicTacToeGame game,
    required this.playerInTurn,
  }) : super(game);
}

class GameOverGamePageState extends GamePageState {
  GameOverGamePageState({required TicTacToeGame game, required this.winner})
      : super(game);
  final String winner;
}
