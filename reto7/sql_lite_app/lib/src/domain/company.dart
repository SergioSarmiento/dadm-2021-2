import 'package:equatable/equatable.dart';

enum Classification {
  consultoria,
  desarrolloMedida,
  fabricaSoftware,
}

class Company extends Equatable {
  Company({
    required this.id,
    required this.name,
    required this.url,
    required this.contactPhone,
    required this.productsAndServices,
    required this.classification,
  });

  final int id;
  final String name;
  final String url;
  final String contactPhone;
  final String productsAndServices;
  final Classification classification;

  @override
  List<Object?> get props => [
        id,
        name,
        url,
        contactPhone,
        productsAndServices,
        classification,
      ];
}
