import 'package:equatable/equatable.dart';
import 'package:fram_flutter_assignment/src/base/enums.dart';
import 'package:fram_flutter_assignment/src/base/utils.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/address.dart';
import 'package:json_annotation/json_annotation.dart';

part "person.g.dart";

@JsonSerializable(createToJson: false)
class Person extends Equatable {
  final int id;
  final String email;
  @JsonKey(name: "lastname")
  final String lastName;
  @JsonKey(name: "firstname")
  final String firstName;
  final String image;
  @JsonKey(fromJson: parseDateTime)
  final DateTime birthday;
  @JsonKey(fromJson: parseGender)
  final Gender gender;
  @JsonKey(name: "website")
  final String websiteUrl;
  final String phone;
  final Address address;

  String get name => "$firstName $lastName";

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);


  Person(
      {required this.id,
      required this.email,
      required this.lastName,
      required this.firstName,
      required this.image,
      required this.birthday,
      required this.gender,
      required this.websiteUrl, 
      required this.phone,
      required this.address
      });

  @override
  List<Object?> get props => [
        id,
        email,
        lastName,
        firstName,
        image,
        birthday,
        gender, 
        websiteUrl, 
        phone,
        address
  ];
}
