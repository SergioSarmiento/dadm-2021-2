import 'package:flutter/material.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form.dart';

import 'bloc/main_page_bloc/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/companyForm': (context) => const CompanyForm(),
      },
    );
  }
}
