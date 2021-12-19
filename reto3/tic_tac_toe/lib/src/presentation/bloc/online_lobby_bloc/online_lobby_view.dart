import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_state.dart';
import '/src/core/constants.dart' as constants;

class OnlineLobbyView extends StatelessWidget {
  const OnlineLobbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('online lobby')),
        body: BlocBuilder<OnlineLobbyCubit, OnlineLobbyState>(
          builder: (context, state) {
            if (state is DisplayMenuOnlineLobbyState ||
                state is EditingNameOnlineLobbyState) {
              return OnlineLobbyMenu(state: state);
            } else if (state is WaitingOnlineLobbyState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SizedBox();
            }
          },
        ));
  }
}

class OnlineLobbyMenu extends StatelessWidget {
  const OnlineLobbyMenu({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnlineLobbyState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          state is DisplayMenuOnlineLobbyState
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Name: ',
                      style: TextStyle(fontSize: constants.fontSize),
                    ),
                    Text(
                      (state as DisplayMenuOnlineLobbyState).name,
                      style: const TextStyle(
                          fontSize: constants.fontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    FloatingActionButton(
                      onPressed: () => context
                          .read<OnlineLobbyCubit>()
                          .editName(
                              (state as DisplayMenuOnlineLobbyState).name),
                      mini: true,
                      child: const Icon(Icons.edit),
                    ),
                  ],
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    onChanged: (newName) =>
                        context.read<OnlineLobbyCubit>().editName(newName),
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      suffixIcon: IconButton(
                        onPressed: () => context
                            .read<OnlineLobbyCubit>()
                            .saveName(
                                (state as EditingNameOnlineLobbyState).name),
                        icon: const Icon(Icons.send),
                      ),
                    ),
                  ),
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<OnlineLobbyCubit>().hostGame(),
                  child: const Text(
                    'Host game',
                    style: TextStyle(fontSize: constants.fontSize),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.read<OnlineLobbyCubit>().joinGame(),
                  child: const Text(
                    'Join game',
                    style: TextStyle(fontSize: constants.fontSize),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
