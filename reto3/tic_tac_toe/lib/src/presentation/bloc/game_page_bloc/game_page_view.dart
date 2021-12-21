import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/tic_tac_toe_game.dart';
import '/src/core/constants.dart' as constants;

class GamePageView extends StatelessWidget {
  const GamePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('play'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<GamePageCubit, GamePageState>(
        builder: (context, state) {
          return OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return PortraitMode(
                state: state,
                context: context,
              );
            } else {
              return LandscapeMode(
                state: state,
                context: context,
              );
            }
          });
        },
      ),
    );
  }
}

class GamePageMessage extends StatelessWidget {
  const GamePageMessage({Key? key, required this.state}) : super(key: key);
  final GamePageState state;

  @override
  Widget build(BuildContext context) {
    if (state is MyTurnGamePageState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            constants.turnText,
            style: TextStyle(fontSize: constants.fontSize),
          ),
          Text((state as MyTurnGamePageState).myName,
              style: TextStyle(
                  fontSize: constants.fontSize,
                  color: (state as MyTurnGamePageState).myName ==
                          state.game.player1
                      ? constants.playerOneColor
                      : constants.playerTwoColor)),
        ],
      );
    } else if (state is GameOverGamePageState) {
      if ((state as GameOverGamePageState).winner == '') {
        return const Text(
          constants.draw,
          style: TextStyle(fontSize: constants.fontSize),
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              constants.winText,
              style: TextStyle(fontSize: constants.fontSize),
            ),
            Text((state as GameOverGamePageState).winner,
                style: TextStyle(
                    fontSize: constants.fontSize,
                    color: (state as GameOverGamePageState).winner ==
                            state.game.player1
                        ? constants.playerOneColor
                        : constants.playerTwoColor)),
          ],
        );
      }
    } else if (state is WaitingGamePageState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            constants.turnText,
            style: TextStyle(fontSize: constants.fontSize),
          ),
          Text(
            state.game.player2,
            style: const TextStyle(
              fontSize: constants.fontSize,
              color: constants.playerTwoColor,
            ),
          ),
          const CircularProgressIndicator(),
        ],
      );
    } else {
      return const Text('An error occured');
    }
  }
}

class PortraitMode extends StatelessWidget {
  const PortraitMode({Key? key, required this.context, required this.state})
      : super(key: key);
  final BuildContext context;
  final GamePageState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Board(
          context: context,
          state: state,
        ),
        GamePageMessage(state: state),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => context.read<GamePageCubit>().newGame(),
              child: const Text(constants.playAgain),
            ),
            ElevatedButton(
              onPressed: () {
                if (state is! WaitingGamePageState) {
                  Navigator.pop(context);
                }
              },
              child: const Text(constants.quit),
            ),
          ],
        ),
      ],
    );
  }
}

class LandscapeMode extends StatelessWidget {
  const LandscapeMode({Key? key, required this.context, required this.state})
      : super(key: key);
  final BuildContext context;
  final GamePageState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Board(
          context: context,
          state: state,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GamePageMessage(state: state),
            ElevatedButton(
              onPressed: () => context.read<GamePageCubit>().newGame(),
              child: const Text(constants.playAgain),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(constants.quit),
            ),
          ],
        )
      ],
    );
  }
}

class Board extends StatelessWidget {
  const Board({
    Key? key,
    required this.context,
    required this.state,
    this.landscape = false,
  }) : super(key: key);
  final BuildContext context;
  final bool landscape;
  final GamePageState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeCell(
              symbol: state.game.cells[0],
              onPressed: () => context.read<GamePageCubit>().cellMarked(0),
              right: true,
              bottom: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(0)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
            TicTacToeCell(
              symbol: state.game.cells[1],
              onPressed: () => context.read<GamePageCubit>().cellMarked(1),
              right: true,
              left: true,
              bottom: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(1)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
            TicTacToeCell(
              symbol: state.game.cells[2],
              onPressed: () => context.read<GamePageCubit>().cellMarked(2),
              bottom: true,
              left: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(2)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeCell(
              symbol: state.game.cells[3],
              onPressed: () => context.read<GamePageCubit>().cellMarked(3),
              top: true,
              right: true,
              bottom: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(3)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
            TicTacToeCell(
              symbol: state.game.cells[4],
              onPressed: () => context.read<GamePageCubit>().cellMarked(4),
              right: true,
              left: true,
              top: true,
              bottom: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(4)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
            TicTacToeCell(
              symbol: state.game.cells[5],
              onPressed: () => context.read<GamePageCubit>().cellMarked(5),
              left: true,
              top: true,
              bottom: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(5)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTacToeCell(
              symbol: state.game.cells[6],
              onPressed: () => context.read<GamePageCubit>().cellMarked(6),
              right: true,
              top: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(6)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
            TicTacToeCell(
              symbol: state.game.cells[7],
              onPressed: () => context.read<GamePageCubit>().cellMarked(7),
              right: true,
              left: true,
              top: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(7)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
            TicTacToeCell(
              symbol: state.game.cells[8],
              onPressed: () => context.read<GamePageCubit>().cellMarked(8),
              top: true,
              left: true,
              color: state is GameOverGamePageState &&
                      state.game.getWinSet().contains(8)
                  ? constants.winningSet
                  : constants.background,
              context: context,
            ),
          ],
        ),
      ],
    );
  }
}

class TicTacToeCell extends StatelessWidget {
  const TicTacToeCell({
    Key? key,
    required this.symbol,
    required this.onPressed,
    required this.context,
    this.top = false,
    this.right = false,
    this.left = false,
    this.bottom = false,
    this.color = Colors.transparent,
  }) : super(key: key);

  final Symbol symbol;
  final bool top;
  final bool right;
  final bool left;
  final bool bottom;
  final BuildContext context;
  final Function() onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          border: Border(
            top: BorderSide(
                width: constants.borderWidth,
                color: top ? constants.borders : constants.background),
            left: BorderSide(
                width: constants.borderWidth,
                color: left ? constants.borders : constants.background),
            right: BorderSide(
                width: constants.borderWidth,
                color: right ? constants.borders : constants.background),
            bottom: BorderSide(
                width: constants.borderWidth,
                color: bottom ? constants.borders : constants.background),
          )),
      child: IconButton(
        onPressed: onPressed,
        iconSize: MediaQuery.of(context).size.height * 0.1,
        icon: symbol == Symbol.x
            ? Image.asset(constants.xImagePath)
            : symbol == Symbol.o
                ? Image.asset(constants.oImagePath)
                : symbol != Symbol.blank
                    ? const Text(constants.error)
                    : const Text(constants.blank),
      ),
    );
  }
}
