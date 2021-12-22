import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';

class GamePageArguments {
  final GameMode gameMode;
  final Difficulty difficulty;
  final String player1;
  final String player2;
  final String roomKey;
  final bool first;

  GamePageArguments({
    required this.gameMode,
    this.difficulty = Difficulty.easy,
    this.player1 = 'player1',
    this.player2 = 'player2',
    this.roomKey = 'no-key',
    this.first = true,
  });
}
