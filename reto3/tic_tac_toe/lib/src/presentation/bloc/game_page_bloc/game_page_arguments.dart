import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';

class GamePageArguments {
  final GameMode gameMode;
  final Difficulty difficulty;

  GamePageArguments(
      {required this.gameMode, this.difficulty = Difficulty.easy});
}
