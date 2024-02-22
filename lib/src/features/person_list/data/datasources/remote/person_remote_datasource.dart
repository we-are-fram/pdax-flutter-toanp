import 'dart:convert';

import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract interface class PersonRemoteDataSource {
  Future<List<Person>> fetchPersons({int limit = 20});
}

@Injectable(as: PersonRemoteDataSource)
class RemotePersonDataSource implements PersonRemoteDataSource {
  Future<List<Person>> fetchPersons({int limit = 20}) async {
    final response = await http.get(Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=${limit}",));
      final List<dynamic> persons = jsonDecode(response.body)['data'];
      return persons.map((e) => Person.fromJson(e)).toList();
  }
}

