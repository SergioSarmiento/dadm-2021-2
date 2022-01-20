import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form_cubit.dart';
import 'package:sql_lite_app/src/presentation/bloc/company_form_bloc/company_form_state.dart';

class CompanyFormView extends StatelessWidget {
  const CompanyFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: BlocBuilder<CompanyFormCubit, CompanyFormState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Ingresa los siguientes datos:',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          initialValue: state.name,
                          onChanged: (text) =>
                              context.read<CompanyFormCubit>().editName(text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'Url',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          initialValue: state.name,
                          onChanged: (text) =>
                              context.read<CompanyFormCubit>().editUrl(text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Telefono de contacto',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          initialValue: state.name,
                          onChanged: (text) =>
                              context.read<CompanyFormCubit>().editPhone(text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Productos y servicios',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          initialValue: state.name,
                          onChanged: (text) => context
                              .read<CompanyFormCubit>()
                              .editProducts(text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButton<String>(
                          hint: const Text('Clasificación de la empresa'),
                          value: state.classification.isEmpty
                              ? null
                              : state.classification,
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
                          onChanged: (value) => context
                              .read<CompanyFormCubit>()
                              .editClassification(value!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: Text(
                    state is CreatingCompanyFormState ? 'Crear' : 'Editar'),
              ),
            ],
          );
        },
      ),
    );
  }
}
