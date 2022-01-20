import 'package:sql_lite_app/src/domain/company.dart';

abstract class MainPageState {}

class DisplayListMainPageState implements MainPageState {
  final List<Company> companies;

  DisplayListMainPageState({
    required this.companies,
  });
}

class WaitingMainPageState implements MainPageState {}
