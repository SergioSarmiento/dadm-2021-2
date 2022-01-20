import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form_state.dart';

class CompanyFormCubit extends Cubit<CompanyFormState> {
  CompanyFormCubit()
      : super(
          EditingCompanyFormState(
              name: '', url: '', phone: '', products: '', classification: ''),
        );

  void editName(String name) {
    if (state is CreatingCompanyFormState) {
      emit(
        CreatingCompanyFormState(
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
          name: state.url,
          url: url,
          phone: state.phone,
          products: state.products,
          classification: state.classification,
        ),
      );
    } else {
      emit(
        EditingCompanyFormState(
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
          name: state.classification,
          url: state.url,
          phone: state.phone,
          products: state.products,
          classification: classification,
        ),
      );
    } else {
      emit(
        EditingCompanyFormState(
          name: state.classification,
          url: state.url,
          phone: state.phone,
          products: state.products,
          classification: classification,
        ),
      );
    }
  }
}
