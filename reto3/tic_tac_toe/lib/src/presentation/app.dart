import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby.dart';
import 'package:tic_tac_toe/src/presentation/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/gamePage': (context) => const GamePage(),
        '/onlineLobby': (context) => const OnlineLobby(),
      },
    );
  }
}
