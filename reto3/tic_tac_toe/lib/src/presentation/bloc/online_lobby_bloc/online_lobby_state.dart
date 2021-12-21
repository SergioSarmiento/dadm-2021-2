import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_room.dart';

abstract class OnlineLobbyState {}

class DisplayMenuOnlineLobbyState implements OnlineLobbyState {
  final String name;

  DisplayMenuOnlineLobbyState({this.name = 'Player1'});
}

class EditingNameOnlineLobbyState implements OnlineLobbyState {
  final String name;

  EditingNameOnlineLobbyState(this.name);
}

class WaitingOnlineLobbyState implements OnlineLobbyState {}

class InRoomWaitingOnlineLobbyState implements OnlineLobbyState {
  final String host;

  InRoomWaitingOnlineLobbyState(this.host);
}

class InRoomReadyOnlineLobbyState implements OnlineLobbyState {
  final OnlineLobbyRoom room;
  final String guest;
  final bool amIHost;

  InRoomReadyOnlineLobbyState(
      {required this.room, required this.guest, required this.amIHost});
}

class AvailableRoomsOnlineLobbyState implements OnlineLobbyState {
  final List<OnlineLobbyRoom> rooms;
  final String name;
  AvailableRoomsOnlineLobbyState({required this.rooms, required this.name});
}

class ErrorOnlineLobbyState implements OnlineLobbyState {
  final String errorMessage;

  ErrorOnlineLobbyState(this.errorMessage);
}
