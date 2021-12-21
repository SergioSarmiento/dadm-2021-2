import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_room.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_state.dart';

class OnlineLobbyCubit extends Cubit<OnlineLobbyState> {
  OnlineLobbyCubit() : super(DisplayMenuOnlineLobbyState());

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
      await Future.delayed(const Duration(seconds: 1));
      emit(InRoomWaitingOnlineLobbyState(playAs));
      await Future.delayed(const Duration(seconds: 2));
      emit(InRoomReadyOnlineLobbyState(
          room: OnlineLobbyRoom(id: 1, host: playAs),
          guest: 'Guest',
          amIHost: true));
    }
  }

  Future<void> joinGame() async {
    if (state is DisplayMenuOnlineLobbyState) {
      final playAs = (state as DisplayMenuOnlineLobbyState).name;
      emit(WaitingOnlineLobbyState());
      await Future.delayed(const Duration(seconds: 1));
      emit(AvailableRoomsOnlineLobbyState(name: playAs, rooms: [
        OnlineLobbyRoom(id: 1, host: 'Bob'),
        OnlineLobbyRoom(id: 2, host: 'Gary'),
        OnlineLobbyRoom(id: 3, host: 'Joey'),
      ]));
    }
  }

  Future<void> joinRoom(OnlineLobbyRoom room) async {
    if (state is AvailableRoomsOnlineLobbyState) {
      final playAs = (state as AvailableRoomsOnlineLobbyState).name;
      emit(WaitingOnlineLobbyState());
      await Future.delayed(const Duration(seconds: 1));
      emit(InRoomReadyOnlineLobbyState(
        room: room,
        guest: playAs,
        amIHost: false,
      ));
    }
  }

  void goBack() {
    emit(DisplayMenuOnlineLobbyState());
  }

  void exitRoom() {
    emit(DisplayMenuOnlineLobbyState());
  }
}
