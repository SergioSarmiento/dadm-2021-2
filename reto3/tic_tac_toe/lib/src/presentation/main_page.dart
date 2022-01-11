import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_arguments.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';
import '/src/core/constants.dart' as constants;

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  List<Widget> getBody(BuildContext context, bool landscape) {
    double x = landscape ? 0.8 : 0.4;
    return [
      Image.asset(
        constants.appIcon,
        scale: 2,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * x,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: const Text(constants.difficultyDialog),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/gamePage',
                          arguments: GamePageArguments(
                            gameMode: GameMode.singlePlayer,
                            difficulty: Difficulty.easy,
                          ),
                        );
                      },
                      child: const Text(constants.difficultyEasy),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/gamePage',
                          arguments: GamePageArguments(
                            gameMode: GameMode.singlePlayer,
                            difficulty: Difficulty.medium,
                          ),
                        );
                      },
                      child: const Text(constants.difficultyMedium),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/gamePage',
                          arguments: GamePageArguments(
                            gameMode: GameMode.singlePlayer,
                            difficulty: Difficulty.hard,
                          ),
                        );
                      },
                      child: const Text(constants.difficultyHard),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.person),
              label: const Text(
                constants.gameModeSinglePlayer,
                style: TextStyle(fontSize: constants.fontSize),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                '/gamePage',
                arguments: GamePageArguments(gameMode: GameMode.twoPlayers),
              ),
              icon: const Icon(Icons.people),
              label: const Text(
                constants.gameModeTwoPlayers,
                style: TextStyle(fontSize: constants.fontSize),
              ),
            ),
            ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/onlineLobby'),
                icon: const Icon(Icons.wifi),
                label: const Text(constants.gameModeOnline,
                    style: TextStyle(fontSize: constants.fontSize))),
            ElevatedButton.icon(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: const Text(constants.quitMessage),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text(constants.dialogCancel),
                    ),
                    TextButton(
                      onPressed: () => SystemNavigator.pop(),
                      child: const Text(constants.dialogOkay),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.exit_to_app),
              label: const Text(
                constants.quit,
                style: TextStyle(fontSize: constants.fontSize),
              ),
            ),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.title),
      ),
      body: Center(
        child: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getBody(context, false),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getBody(context, true),
            );
          }
        }),
      ),
    );
  }
}
