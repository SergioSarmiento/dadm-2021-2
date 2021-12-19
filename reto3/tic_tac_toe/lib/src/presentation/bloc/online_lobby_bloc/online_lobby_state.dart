abstract class OnlineLobbyState {}

class DisplayMenuOnlineLobbyState implements OnlineLobbyState {
  final String name;

  DisplayMenuOnlineLobbyState(this.name);
}

class EditingNameOnlineLobbyState implements OnlineLobbyState {
  final String name;

  EditingNameOnlineLobbyState(this.name);
}

class WaitingOnlineLobbyState implements OnlineLobbyState {}

class InRoomWaitingOnlineLobbyState implements OnlineLobbyState {}

class InRoomReadyOnlineLobbyState implements OnlineLobbyState {}

class AvailableRoomsOnlineLobbyState implements OnlineLobbyState {}

class ErrorOnlineLobbyState implements OnlineLobbyState {}
