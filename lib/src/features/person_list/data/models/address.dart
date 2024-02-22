import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'address.g.dart';

@JsonSerializable(createToJson: false)
class Address extends Equatable {
  final int id;
  final String street;
  final String streetName;
  final String buildingNumber;
  final String city;
  final String zipcode;
  final String country;
  @JsonKey(name: "county_code")
  final String countyCode;
  final double latitude;
  final double longitude;

  Address({
    required this.id,
    required this.street,
    required this.streetName,
    required this.buildingNumber,
    required this.city,
    required this.zipcode,
    required this.country,
    required this.countyCode,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  @override
  List<Object?> get props => [
        id,
        street,
        streetName,
        buildingNumber,
        city,
        zipcode,
        country,
        countyCode,
        latitude,
        longitude
      ];
}
