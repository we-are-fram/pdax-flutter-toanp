// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as int,
      street: json['street'] as String,
      streetName: json['streetName'] as String,
      buildingNumber: json['buildingNumber'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
      country: json['country'] as String,
      countyCode: json['county_code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
