import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_app/src/presentation/bloc/main_page_bloc/main_page_cubit.dart';
import 'package:sql_lite_app/src/presentation/bloc/main_page_bloc/main_page_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainPageCubit(),
      child: MainPageView(),
    );
  }
}
