// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fram_flutter_assignment/src/di/injection.dart' as _i6;
import 'package:fram_flutter_assignment/src/features/person_list/data/datasources/remote/person_remote_datasource.dart'
    as _i4;
import 'package:fram_flutter_assignment/src/features/person_list/data/repositories/person_repository.dart'
    as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
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
    final registerModule = _$RegisterModule();
    gh.factory<_i3.Client>(() => registerModule.httpClient);
    gh.factory<_i4.PersonRemoteDataSource>(
        () => _i4.PersonRemoteDataSourceImpl(client: gh<_i3.Client>()));
    gh.factory<_i5.PersonRepository>(() => _i5.PersonRepositoryImpl(
        remoteDataSource: gh<_i4.PersonRemoteDataSource>()));
    return this;
  }
}

class _$RegisterModule extends _i6.RegisterModule {}
