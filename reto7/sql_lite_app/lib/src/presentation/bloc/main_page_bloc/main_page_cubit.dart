import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_lite_app/src/domain/company.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form_arguments.dart';
import 'package:sql_lite_app/src/presentation/bloc/main_page_bloc/main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  late final Database database;

  MainPageCubit() : super(WaitingMainPageState());

  Future<void> start() async {
    try {
      await openDB();
    } catch (e) {}
    final list = await getFullList();
    emit(DisplayListMainPageState(
      companies: list,
    ));
  }

  Future<void> filterList(bool byName, String value) async {
    if (byName) {
      final list = await getListSortedByName(value);
      emit(
        DisplayListMainPageState(
          companies: list,
        ),
      );
    } else {
      final list = await getListSortedByClass(value);
      emit(
        DisplayListMainPageState(
          companies: list,
        ),
      );
    }
  }

  void refresh() {
    emit(WaitingMainPageState());
  }

  Future<void> openDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_db.db');

    try {
      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Companies (id INTEGER PRIMARY KEY, name TEXT, url TEXT, phone TEXT, products TEXT, classification TEXT)');
      });
    } catch (e) {
      print('error opening database: ${e.toString()}');
    }
  }

  Future<void> closeDB() async {
    await database.close();
  }

  Future<List<Company>> getFullList() async {
    List<Map> list = await database.rawQuery('SELECT * FROM Companies');
    return list
        .map(
          (e) => Company(
            id: e['id'],
            name: e['name'],
            url: e['url'],
            contactPhone: e['phone'],
            productsAndServices: e['products'],
            classification: e['classification'] == 'Consultoria'
                ? Classification.consultoria
                : e['classification'] == 'Desarrollo a la medida'
                    ? Classification.desarrolloMedida
                    : Classification.fabricaSoftware,
          ),
        )
        .toList();
  }

  Future<List<Company>> getListSortedByClass(String classification) async {
    List<Map> list = await database.rawQuery(
        'SELECT * FROM Companies WHERE classification == "${classification}"');
    return list
        .map(
          (e) => Company(
            id: e['id'],
            name: e['name'],
            url: e['url'],
            contactPhone: e['phone'],
            productsAndServices: e['products'],
            classification: e['classification'] == 'Consultoria'
                ? Classification.consultoria
                : e['classification'] == 'Desarrollo a la medida'
                    ? Classification.desarrolloMedida
                    : Classification.fabricaSoftware,
          ),
        )
        .toList();
  }

  Future<List<Company>> getListSortedByName(String name) async {
    List<Map> list = await database.rawQuery(
        'SELECT * FROM Companies WHERE name LIKE "${name}%" OR name LIKE "%${name}" OR name LIKE "%${name}%" ');
    return list
        .map(
          (e) => Company(
            id: e['id'],
            name: e['name'],
            url: e['url'],
            contactPhone: e['phone'],
            productsAndServices: e['products'],
            classification: e['classification'] == 'Consultoria'
                ? Classification.consultoria
                : e['classification'] == 'Desarrollo a la medida'
                    ? Classification.desarrolloMedida
                    : Classification.fabricaSoftware,
          ),
        )
        .toList();
  }

  void pushFormPage({required BuildContext context, Company? company}) {
    Navigator.pushNamed(
      context,
      '/companyForm',
      arguments: CompanyFormArguments(
        database: database,
        company: company,
      ),
    );
  }

  Future<void> deleteCompany(String name) async {
    try {
      await database.rawDelete('DELETE FROM Companies WHERE name = "${name}"');
      emit(WaitingMainPageState());
    } catch (e) {
      print(e);
    }
  }

  void ShowDialogToDelete(
      {required BuildContext context, required String name}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Eliminar registro'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              deleteCompany(name);
              Navigator.pop(context);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
