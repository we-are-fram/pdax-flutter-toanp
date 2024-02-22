import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract interface class PersonRemoteDataSource {
  Future<List<dynamic>> fetchPersonData({int limit = 20});
}

@Injectable(as: PersonRemoteDataSource)
class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final http.Client client;
  PersonRemoteDataSourceImpl({@injectable required this.client});

  Future<List<dynamic>> fetchPersonData({int limit = 20}) async {
    final response = await client.get(Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=${limit}",));
      final List<dynamic> persons = jsonDecode(response.body)['data'];
      return persons.take(limit).toList();
  }
}

