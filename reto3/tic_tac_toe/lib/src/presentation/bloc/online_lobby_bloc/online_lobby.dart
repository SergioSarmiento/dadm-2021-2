import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_view.dart';

class OnlineLobby extends StatelessWidget {
  const OnlineLobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnlineLobbyCubit(),
      child: const OnlineLobbyView(),
    );
  }
}
