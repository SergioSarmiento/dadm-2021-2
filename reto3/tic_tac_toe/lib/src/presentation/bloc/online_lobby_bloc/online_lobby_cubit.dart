import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tic_tac_toe/src/data/room_dao.dart';

import 'package:tic_tac_toe/src/domain/room.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_arguments.dart';
import 'package:tic_tac_toe/src/presentation/bloc/game_page_bloc/game_page_state.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_room.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_state.dart';

class OnlineLobbyCubit extends Cubit<OnlineLobbyState> {
  OnlineLobbyCubit() : super(DisplayMenuOnlineLobbyState());

  final roomDao = RoomDao();

  void editName(String newName) {
    if (state is DisplayMenuOnlineLobbyState ||
        state is EditingNameOnlineLobbyState) {
      emit(EditingNameOnlineLobbyState(newName));
    }
  }

  void saveName(String newName) {
    final nameToSave = newName.replaceAll(' ', '');
    if (state is EditingNameOnlineLobbyState && nameToSave != '') {
      emit(DisplayMenuOnlineLobbyState(name: nameToSave));
    }
  }

  Future<void> hostGame() async {
    if (state is DisplayMenuOnlineLobbyState) {
      final playAs = (state as DisplayMenuOnlineLobbyState).name;
      emit(WaitingOnlineLobbyState());
      final key = roomDao.saveRoom(Room(host: playAs, guest: ''));
      emit(InRoomWaitingOnlineLobbyState(host: playAs, roomKey: key));
      final instance = roomDao.getInstance();
      instance.child(key).onChildChanged.listen((event) {
        final guest = event.snapshot.value as String;
        emit(
          InRoomReadyOnlineLobbyState(
            room: OnlineLobbyRoom(
                host: (state as InRoomWaitingOnlineLobbyState).host,
                id: (state as InRoomWaitingOnlineLobbyState).roomKey),
            guest: guest,
            amIHost: true,
          ),
        );
        return;
      });
    }
  }

  Future<void> joinGame() async {
    if (state is DisplayMenuOnlineLobbyState) {
      final playAs = (state as DisplayMenuOnlineLobbyState).name;
      emit(WaitingOnlineLobbyState());

      final rooms = await roomDao.getRooms();

      emit(AvailableRoomsOnlineLobbyState(
          name: playAs,
          rooms: rooms
              .map((e) => OnlineLobbyRoom(host: e.host, id: e.id))
              .toList()));
    }
  }

  Future<void> joinRoom(OnlineLobbyRoom room) async {
    if (state is AvailableRoomsOnlineLobbyState) {
      final playAs = (state as AvailableRoomsOnlineLobbyState).name;
      emit(WaitingOnlineLobbyState());

      if (await roomDao
          .enterRoom(Room(id: room.id, host: room.host, guest: playAs))) {
        emit(
          InRoomReadyOnlineLobbyState(
            room: room,
            guest: playAs,
            amIHost: false,
          ),
        );

        final instance = roomDao.getInstance();
        instance
            .child((state as InRoomReadyOnlineLobbyState).room.id)
            .limitToLast(1)
            .onChildChanged
            .listen((event) {
          if (state is InRoomReadyOnlineLobbyState) {
            emit(StartingGameOnlineLobbyState(
              room: (state as InRoomReadyOnlineLobbyState).room,
              guest: (state as InRoomReadyOnlineLobbyState).guest,
              first: false,
            ));
          }
          return;
        });
      } else {
        emit(DisplayMenuOnlineLobbyState(name: playAs));
      }
    }
  }

  void goBack() {
    emit(DisplayMenuOnlineLobbyState());
  }

  void startGame() async {
    if (state is InRoomReadyOnlineLobbyState) {
      final room = (state as InRoomReadyOnlineLobbyState).room;
      final result = await roomDao.startGame(
        Room(
          id: room.id,
          host: room.host,
          guest: (state as InRoomReadyOnlineLobbyState).guest,
        ),
      );
      if (result) {
        emit(
          StartingGameOnlineLobbyState(
              room: room, guest: (state as InRoomReadyOnlineLobbyState).guest),
        );
      } else {
        emit(DisplayMenuOnlineLobbyState());
      }
    }
  }

  void startingGame(BuildContext context, bool first) async {
    await Future.delayed(const Duration(seconds: 1));
    if (state is StartingGameOnlineLobbyState) {
      final StartingGameOnlineLobbyState startingState =
          state as StartingGameOnlineLobbyState;
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/gamePage',
        arguments: GamePageArguments(
          gameMode: GameMode.online,
          player1: startingState.room.host,
          player2: startingState.guest,
          roomKey: startingState.room.id,
          first: first,
        ),
      );
    }
  }

  void exitRoom() {
    if (state is InRoomWaitingOnlineLobbyState) {
      final key = (state as InRoomWaitingOnlineLobbyState).roomKey;
      roomDao.deleteRoom(key);
      emit(DisplayMenuOnlineLobbyState(
          name: (state as InRoomWaitingOnlineLobbyState).host));
    } else if (state is InRoomReadyOnlineLobbyState) {
      final room = (state as InRoomReadyOnlineLobbyState).room;
      if ((state as InRoomReadyOnlineLobbyState).amIHost) {
        roomDao.deleteRoom(room.id);
        emit(DisplayMenuOnlineLobbyState(name: room.host));
      } else {
        roomDao.exitRoom(
          Room(id: room.id, host: room.host, guest: ''),
        );
        emit(DisplayMenuOnlineLobbyState(
            name: (state as InRoomReadyOnlineLobbyState).guest));
      }
    }
  }
}
