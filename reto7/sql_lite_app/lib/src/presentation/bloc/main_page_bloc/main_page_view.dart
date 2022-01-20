import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_app/src/domain/company.dart';
import 'package:sql_lite_app/src/presentation/bloc/main_page_bloc/main_page_cubit.dart';
import 'package:sql_lite_app/src/presentation/bloc/main_page_bloc/main_page_state.dart';

class MainPageView extends StatelessWidget {
  const MainPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio de empresas'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => Navigator.pushNamed(context, '/companyForm'),
      ),
      body: BlocBuilder<MainPageCubit, MainPageState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  onChanged: (newName) => name = newName,
                  decoration: InputDecoration(
                    hintText: 'Nombre de empresa',
                    suffixIcon: IconButton(
                      onPressed: () {
                        print(name);
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ),
              ),
              DropdownButton<String>(
                hint: const Text('Clasificación'),
                items: <String>[
                  'Consultoria',
                  'Desarrollo a la medida',
                  'Fabrica de Software'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              Expanded(
                child: ListView(
                  children: (state as DisplayListMainPageState)
                      .companies
                      .map(
                        (e) => Card(
                          child: ExpansionTile(
                            title: Text(e.name),
                            childrenPadding: EdgeInsets.all(10.0),
                            children: [
                              Row(
                                children: [const Text('Url: '), Text(e.url)],
                              ),
                              Row(
                                children: [
                                  const Text('Teléfono: '),
                                  Text(e.contactPhone)
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Productos & Servicios: '),
                                  Text(e.productsAndServices)
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Clasificación: '),
                                  Text(e.classification ==
                                          Classification.consultoria
                                      ? 'Consultoria'
                                      : e.classification ==
                                              Classification.desarrolloMedida
                                          ? 'Desarrollo a la medida'
                                          : 'Fabrica de Software')
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.edit),
                                      label: Text('Editar')),
                                  TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete),
                                      label: Text('Borrar')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
