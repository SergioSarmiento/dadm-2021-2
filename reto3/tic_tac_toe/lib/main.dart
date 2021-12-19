import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/src/presentation/app.dart';
import 'package:tic_tac_toe/src/presentation/bloc/app_bloc_observer.dart';

void main() async {
  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: AppBlocObserver(),
  );
}
