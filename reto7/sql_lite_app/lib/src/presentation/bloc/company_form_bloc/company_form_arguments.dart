import 'package:sqflite/sqflite.dart';
import 'package:sql_lite_app/src/domain/company.dart';

class CompanyFormArguments {
  final Database database;
  final Company? company;

  CompanyFormArguments({
    required this.database,
    this.company,
  });
}
