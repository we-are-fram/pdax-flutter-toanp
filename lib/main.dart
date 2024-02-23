import 'package:flutter/material.dart';
import 'package:fram_flutter_assignment/src/base/router.dart';
import 'package:fram_flutter_assignment/src/di/injection.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presentation/ui/pages/person_list_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: PersonListPage.routeName,
      onGenerateRoute: onGenerateRoute
    );
  }
}
