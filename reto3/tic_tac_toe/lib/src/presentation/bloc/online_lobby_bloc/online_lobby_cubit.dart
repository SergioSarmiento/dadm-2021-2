import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/bloc/online_lobby_bloc/online_lobby_state.dart';

class OnlineLobbyCubit extends Cubit<OnlineLobbyState> {
  OnlineLobbyCubit() : super(DisplayMenuOnlineLobbyState('Player1'));

  void editName(String newName) {
    if (state is DisplayMenuOnlineLobbyState ||
        state is EditingNameOnlineLobbyState) {
      emit(EditingNameOnlineLobbyState(newName));
    }
  }

  void saveName(String newName) {
    final nameToSave = newName.replaceAll(' ', '');
    if (state is EditingNameOnlineLobbyState && nameToSave != '') {
      emit(DisplayMenuOnlineLobbyState(nameToSave));
    }
  }

  Future<void> hostGame() async {
    if (state is DisplayMenuOnlineLobbyState) {
      emit(WaitingOnlineLobbyState());
      await Future.delayed(const Duration(seconds: 1));
      emit(DisplayMenuOnlineLobbyState('Host'));
    }
  }

  Future<void> joinGame() async {
    if (state is DisplayMenuOnlineLobbyState) {
      emit(WaitingOnlineLobbyState());
      await Future.delayed(const Duration(seconds: 1));
      emit(DisplayMenuOnlineLobbyState('Guest'));
    }
  }
}
