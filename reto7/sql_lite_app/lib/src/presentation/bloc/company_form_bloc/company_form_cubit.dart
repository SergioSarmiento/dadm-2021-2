import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_lite_app/src/domain/company.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form_state.dart';

class CompanyFormCubit extends Cubit<CompanyFormState> {
  CompanyFormCubit({
    required this.database,
    Company? company,
  }) : super(company == null
            ? CreatingCompanyFormState(
                id: 0,
                name: '',
                url: '',
                phone: '',
                products: '',
                classification: '')
            : EditingCompanyFormState(
                id: company.id,
                name: company.name,
                url: company.url,
                phone: company.contactPhone,
                products: company.productsAndServices,
                classification: company.classification ==
                        Classification.consultoria
                    ? 'Consultoria'
                    : company.classification == Classification.desarrolloMedida
                        ? 'Desarrollo a la medida'
                        : 'Fabrica de Software',
              ));

  final Database database;

  void editName(String name) {
    if (state is CreatingCompanyFormState) {
      emit(
        CreatingCompanyFormState(
          id: state.id,
          name: name,
          url: state.url,
          phone: state.phone,
          products: state.products,
          classification: state.classification,
        ),
      );
    } else {
      emit(
        EditingCompanyFormState(
          id: state.id,
          name: name,
          url: state.url,
          phone: state.phone,
          products: state.products,
          classification: state.classification,
        ),
      );
    }
  }

  void editUrl(String url) {
    if (state is CreatingCompanyFormState) {
      emit(
        CreatingCompanyFormState(
          id: state.id,
          name: state.name,
          url: url,
          phone: state.phone,
          products: state.products,
          classification: state.classification,
        ),
      );
    } else {
      emit(
        EditingCompanyFormState(
          id: state.id,
          name: state.name,
          url: url,
          phone: state.phone,
          products: state.products,
          classification: state.classification,
        ),
      );
    }
  }

  void editPhone(String phone) {
    if (state is CreatingCompanyFormState) {
      emit(
        CreatingCompanyFormState(
          id: state.id,
          name: state.name,
          url: state.url,
          phone: phone,
          products: state.products,
          classification: state.classification,
        ),
      );
    } else {
      emit(
        EditingCompanyFormState(
          id: state.id,
          name: state.name,
          url: state.url,
          phone: phone,
          products: state.products,
          classification: state.classification,
        ),
      );
    }
  }

  void editProducts(String products) {
    if (state is CreatingCompanyFormState) {
      emit(
        CreatingCompanyFormState(
          id: state.id,
          name: state.name,
          url: state.url,
          phone: state.phone,
          products: products,
          classification: state.classification,
        ),
      );
    } else {
      emit(
        EditingCompanyFormState(
          id: state.id,
          name: state.name,
          url: state.url,
          phone: state.phone,
          products: products,
          classification: state.classification,
        ),
      );
    }
  }

  void editClassification(String classification) {
    if (state is CreatingCompanyFormState) {
      emit(
        CreatingCompanyFormState(
          id: state.id,
          name: state.name,
          url: state.url,
          phone: state.phone,
          products: state.products,
          classification: classification,
        ),
      );
    } else {
      emit(
        EditingCompanyFormState(
          id: state.id,
          name: state.name,
          url: state.url,
          phone: state.phone,
          products: state.products,
          classification: classification,
        ),
      );
    }
  }

  Future<void> finish(BuildContext context) async {
    if (state.name.isNotEmpty &&
        state.url.isNotEmpty &&
        state.phone.isNotEmpty &&
        state.products.isNotEmpty &&
        state.classification.isNotEmpty) {
      try {
        if (state is CreatingCompanyFormState) {
          await database.transaction(
            (txn) async {
              int id1 = await txn.rawInsert(
                  'INSERT INTO Companies(name, url, phone, products, classification) VALUES("${state.name}", "${state.url}", "${state.phone}", "${state.products}", "${state.classification}")');
            },
          );
        } else {
          await database.rawUpdate(
            'UPDATE Companies SET name = "${state.name}", url = "${state.url}", phone = "${state.phone}", products = "${state.products}", classification = "${state.classification}" WHERE id = "${state.id}"',
          );
        }
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }
}
