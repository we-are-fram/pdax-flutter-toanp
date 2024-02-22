import 'package:fram_flutter_assignment/src/features/person_list/data/datasources/remote/person_remote_datasource.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';
import 'package:injectable/injectable.dart';

abstract interface class PersonRepository {
  Future<List<Person>> fetchPersons({int limit = 20});
}

@Injectable(as: PersonRepository)
class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;

  PersonRepositoryImpl({@injectable required this.remoteDataSource});

  Future<List<Person>> fetchPersons({int limit = 20}) async {
    return remoteDataSource.fetchPersons(limit: limit);
  }
}
