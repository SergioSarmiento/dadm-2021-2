import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_cubit.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_room.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_state.dart';
import '/src/core/constants.dart' as constants;

class OnlineLobbyView extends StatelessWidget {
  const OnlineLobbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('online lobby'),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<OnlineLobbyCubit, OnlineLobbyState>(
          builder: (context, state) {
            if (state is DisplayMenuOnlineLobbyState ||
                state is EditingNameOnlineLobbyState) {
              return OnlineLobbyMenu(state: state);
            } else if (state is WaitingOnlineLobbyState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AvailableRoomsOnlineLobbyState) {
              return AvailableRooms(
                rooms: (state).rooms,
              );
            } else if (state is InRoomWaitingOnlineLobbyState ||
                state is InRoomReadyOnlineLobbyState) {
              return LobbyRoom(state: state);
            } else {
              return SizedBox();
            }
          },
        ));
  }
}

class LobbyRoom extends StatelessWidget {
  const LobbyRoom({Key? key, required this.state}) : super(key: key);
  final OnlineLobbyState state;

  @override
  Widget build(BuildContext context) {
    if (state is InRoomWaitingOnlineLobbyState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Waiting for opponent...',
              style: Theme.of(context).textTheme.headline5,
            ),
            ElevatedButton(
                onPressed: () => context.read<OnlineLobbyCubit>().exitRoom(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: constants.fontSize),
                )),
          ],
        ),
      );
    } else {
      final readyState = (state as InRoomReadyOnlineLobbyState);
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  '${readyState.room.host} vs ${readyState.guest}',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              readyState.amIHost
                  ? ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Start Game',
                        style: TextStyle(fontSize: constants.fontSize),
                      ))
                  : Center(
                      child: Text(
                          'Waiting for ${readyState.room.host} to start game...')),
              ElevatedButton(
                  onPressed: () => context.read<OnlineLobbyCubit>().exitRoom(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: constants.fontSize),
                  )),
            ],
          ),
        ),
      );
    }
  }
}

class AvailableRooms extends StatelessWidget {
  const AvailableRooms({Key? key, required this.rooms}) : super(key: key);

  final List<OnlineLobbyRoom> rooms;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Available players:',
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rooms
                  .map(
                    (e) => Card(
                      child: ListTile(
                        title: Text(e.host),
                        trailing: Icon(Icons.play_arrow_rounded),
                        onTap: () =>
                            context.read<OnlineLobbyCubit>().joinRoom(e),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        ElevatedButton.icon(
            onPressed: () => context.read<OnlineLobbyCubit>().goBack(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Quit')),
      ],
    );
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
            height: MediaQuery.of(context).size.height * 0.5,
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
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back',
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
