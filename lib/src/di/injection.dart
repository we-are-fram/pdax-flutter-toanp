import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;  

@InjectableInit(generateForDir: ["lib"])
configureDependencies() => getIt.init();


@module  
abstract class RegisterModule {  
  http.Client get httpClient => http.Client();  
}  