// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      id: json['id'] as int,
      email: json['email'] as String,
      lastName: json['lastname'] as String,
      firstName: json['firstname'] as String,
      image: json['image'] as String,
      birthday: parseDateTime(json['birthday'] as String),
      gender: parseGender(json['gender'] as String),
      websiteUrl: json['website'] as String,
      phone: json['phone'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );
