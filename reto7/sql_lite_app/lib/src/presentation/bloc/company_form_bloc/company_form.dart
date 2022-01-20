import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form_cubit.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form_view.dart';

class CompanyForm extends StatelessWidget {
  const CompanyForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompanyFormCubit(),
      child: CompanyFormView(),
    );
  }
}
