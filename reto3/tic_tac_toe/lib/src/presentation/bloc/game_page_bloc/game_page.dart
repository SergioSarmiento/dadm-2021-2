import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_arguments.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_view.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/tic_tac_toe_game.dart';
import '/src/core/constants.dart' as constants;

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as GamePageArguments;
    final game = TicTacToeGame(
      player1: args.player1,
      player2: args.gameMode == GameMode.singlePlayer
          ? constants.computerName
          : args.player2,
    );
    return BlocProvider(
      create: (_) => GamePageCubit(
        gameMode: args.gameMode,
        difficulty: args.difficulty,
        game: game,
        initialState: args.first
            ? MyTurnGamePageState(
                game: game,
                myName: game.player1,
              )
            : WaitingGamePageState(
                game: game,
                playerInTurn: game.player1,
              ),
        key: args.roomKey,
      ),
      child: const GamePageView(),
    );
  }
}
