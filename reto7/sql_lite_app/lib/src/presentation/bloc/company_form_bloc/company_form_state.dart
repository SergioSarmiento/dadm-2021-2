class CompanyFormState {
  final String name;
  final String url;
  final String phone;
  final String products;
  final String classification;

  CompanyFormState({
    required this.name,
    required this.url,
    required this.phone,
    required this.products,
    required this.classification,
  });
}

class CreatingCompanyFormState extends CompanyFormState {
  CreatingCompanyFormState(
      {required String name,
      required String url,
      required String phone,
      required String products,
      required String classification})
      : super(
          name: name,
          url: url,
          phone: phone,
          products: products,
          classification: classification,
        );
}

class EditingCompanyFormState extends CompanyFormState {
  EditingCompanyFormState(
      {required String name,
      required String url,
      required String phone,
      required String products,
      required String classification})
      : super(
          name: name,
          url: url,
          phone: phone,
          products: products,
          classification: classification,
        );
}
