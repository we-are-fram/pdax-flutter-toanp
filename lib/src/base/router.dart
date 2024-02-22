import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fram_flutter_assignment/src/di/injection.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/blocs/person_list/person_list_bloc.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/pages/person_detail_page.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/pages/person_list_page.dart';

Route onGenerateRoute<T>(RouteSettings settings) {
  RouteSettings routeSettings = settings;
  Widget page = BlocProvider<PersonListBloc>(
        create: (context) => getIt<PersonListBloc>()..add(FetchPersons()),
        child: PersonListPage());

  if (settings.name == PersonDetailPage.routeName) {
    Person? person = settings.arguments as Person?;
    if (person != null) {
      page = PersonDetailPage(person: person);
    } else {
      routeSettings = RouteSettings(name: PersonListPage.routeName);
    }
  }
  

  return MaterialPageRoute<void>(
    builder: (context) => page,
    settings: routeSettings,
  );
}
