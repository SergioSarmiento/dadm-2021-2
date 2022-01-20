import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_app/src/domain/company.dart';
import 'package:sql_lite_app/src/presentation/bloc/main_page_bloc/main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit()
      : super(DisplayListMainPageState(
          companies: [
            Company(
              name: 'alpina',
              url: 'www.aplina.com',
              contactPhone: '123456789',
              productsAndServices: 'productos lacteos',
              classification: Classification.consultoria,
            ),
            Company(
              name: 'alpina',
              url: 'www.aplina.com',
              contactPhone: '123456789',
              productsAndServices: 'productos lacteos',
              classification: Classification.consultoria,
            ),
            Company(
              name: 'alpina',
              url: 'www.aplina.com',
              contactPhone: '123456789',
              productsAndServices: 'productos lacteos',
              classification: Classification.consultoria,
            ),
            Company(
              name: 'alpina',
              url: 'www.aplina.com',
              contactPhone: '123456789',
              productsAndServices: 'productos lacteos',
              classification: Classification.consultoria,
            ),
            Company(
              name: 'alpina',
              url: 'www.aplina.com',
              contactPhone: '123456789',
              productsAndServices: 'productos lacteos',
              classification: Classification.consultoria,
            ),
          ],
          filter: 0,
        ));
}
