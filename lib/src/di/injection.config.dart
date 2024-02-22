// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fram_flutter_assignment/src/features/person_list/data/datasources/remote/person_remote_datasource.dart'
    as _i3;
import 'package:fram_flutter_assignment/src/features/person_list/data/repositories/person_repository.dart'
    as _i4;
import 'package:fram_flutter_assignment/src/features/person_list/presenter/blocs/person_list/person_list_bloc.dart'
    as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.PersonRemoteDataSource>(() => _i3.RemotePersonDataSource());
    gh.factory<_i4.PersonRepository>(() => _i4.PersonRepositoryImpl(
        remoteDataSource: gh<_i3.PersonRemoteDataSource>()));
    gh.factory<_i5.PersonListBloc>(
        () => _i5.PersonListBloc(personRepository: gh<_i4.PersonRepository>()));
    return this;
  }
}
