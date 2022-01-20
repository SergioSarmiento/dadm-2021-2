import 'package:sql_lite_app/src/domain/company.dart';

abstract class MainPageState {}

class DisplayListMainPageState implements MainPageState {
  final List<Company> companies;
  final int filter;
  DisplayListMainPageState({
    required this.companies,
    required this.filter,
  });
}
