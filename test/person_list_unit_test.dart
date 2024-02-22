import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/datasources/remote/person_remote_datasource.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/repositories/person_repository.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/blocs/person_list/person_list_bloc.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/pages/person_detail_page.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/pages/person_list_page.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/widgets/person_list_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:nock/nock.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'bloc_test.mocks.dart';

import 'raw_data.dart';

void main() {
  var httpClient = MockClient();
  var dataSource = PersonRemoteDataSourceImpl(client: httpClient);
  final repository = PersonRepositoryImpl(remoteDataSource: dataSource);

  setUpAll(nock.init);

  setUp(() {
    reset(httpClient);
    nock.cleanAll();
    when(httpClient
            .get(Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=20")))
        .thenAnswer((_) async => http.Response(rawData, 200));
    when(httpClient
            .get(Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=10")))
        .thenAnswer((_) async => http.Response(rawData, 200));
  });

  test('test name', () async {
    var persons = await repository.fetchPersons(limit: 10);
    expect(persons, isA<List<dynamic>>());
    expect(persons.length, 10);

    persons = await repository.fetchPersons(limit: 20);
    expect(persons, isA<List<dynamic>>());
    expect(persons.length, 20);
  });

  blocTest("Test for fetch persons event",
      build: () => PersonListBloc(personRepository: repository),
      act: (bloc) => bloc.add(FetchPersons()),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) {
        verify(httpClient.get(
                Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=10")))
            .called(2);
      },
      expect: () async {
        return [
          PersonListState.initial().copyWith(status: PersonListStatus.fetching),
          PersonListState.initial()
              .copyWith(status: PersonListStatus.fetching)
              .copyWith(
                  status: PersonListStatus.loaded,
                  personList: await repository.fetchPersons(limit: 10),
                  currentPage: 1,
                  hasReachedEnd: false)
        ];
      });

  blocTest("Test for refresh persons event",
      build: () => PersonListBloc(personRepository: repository),
      act: (bloc) => bloc
        ..add(FetchPersons())
        ..add(FetchPersons(isRefresh: true)),
      wait: const Duration(milliseconds: 5000),
      verify: (bloc) {
        verify(httpClient.get(
                Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=10")))
            .called(4);
      },
      expect: () async {
        var initialState = PersonListState.initial();
        var states = [];
        states.add(initialState.copyWith(status: PersonListStatus.fetching));
        states.add(states.last.copyWith(
            status: PersonListStatus.loaded,
            personList: await repository.fetchPersons(limit: 10),
            currentPage: 1,
            hasReachedEnd: false));
        states.add(states.last.copyWith(status: PersonListStatus.refreshing));
        states.add(states.last.copyWith(
            status: PersonListStatus.loaded,
            personList: await repository.fetchPersons(limit: 10),
            currentPage: 1,
            hasReachedEnd: false));

        return states;
      });

  blocTest("Test for loadmore persons event",
      build: () => PersonListBloc(personRepository: repository),
      act: (bloc) => bloc
        ..add(FetchPersons())
        ..add(LoadmorePersons(page: 2, limit: 20)),
      wait: const Duration(milliseconds: 5000),
      expect: () async {
        var initialState = PersonListState.initial();
        var states = [];

        var tenPersons = await repository.fetchPersons(limit: 10);
        var twentyPersons = await repository.fetchPersons(limit: 20);
        states.add(initialState.copyWith(status: PersonListStatus.fetching));
        states.add(states.last.copyWith(
            status: PersonListStatus.loaded,
            personList: tenPersons,
            currentPage: 1,
            hasReachedEnd: false));
        states.add(states.last.copyWith(status: PersonListStatus.loadingMore));
        states.add(states.last.copyWith(
            status: PersonListStatus.loaded,
            personList: [...tenPersons, ...twentyPersons],
            currentPage: 2,
            hasReachedEnd: false));

        return states;
      });

  blocTest("Test for loadmore reached end persons event",
      build: () => PersonListBloc(personRepository: repository),
      act: (bloc) => bloc
        ..add(FetchPersons())
        ..add(LoadmorePersons(page: 2, limit: 20))
        ..add(LoadmorePersons(page: 3, limit: 20))
        ..add(LoadmorePersons(page: 4, limit: 20)),
      wait: const Duration(milliseconds: 5000),
      expect: () async {
        var initialState = PersonListState.initial();
        List<PersonListState> states = [];

        var tenPersons = await repository.fetchPersons(limit: 10);
        var twentyPersons = await repository.fetchPersons(limit: 20);
        states.add(initialState.copyWith(status: PersonListStatus.fetching));
        states.add(states.last.copyWith(
            status: PersonListStatus.loaded,
            personList: tenPersons,
            currentPage: 1,
            hasReachedEnd: false));

        for (var currentPage in List.generate(3, (index) => index + 2)) {
          states
              .add(states.last.copyWith(status: PersonListStatus.loadingMore));
          states.add(states.last.copyWith(
              status: PersonListStatus.loaded,
              personList: [...states.last.personList, ...twentyPersons],
              currentPage: currentPage,
              hasReachedEnd: currentPage == 4));
        }

        return states;
      });

  testWidgets('Test widgets rendering with status code 200',
      (WidgetTester tester) async {
    nock('https://fakerapi.it')
        .get('/api/v1/persons?_quantity=10')
        .reply(200, rawData);

    nock('https://fakerapi.it')
        .get('/api/v1/persons?_quantity=20')
        .reply(200, rawData);

    final bloc = PersonListBloc(personRepository: repository);
    await tester.pumpWidget(MyTestApp(bloc: bloc));

    expect(find.text('Person List'), findsOneWidget);
    expect(find.byType(PersonListWidget), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);

    expect(tester.widgetList<ListView>(find.byType(ListTile)).length, 10);

    // First person in the list, index = 0
    expect(find.widgetWithText(ListTile, "Rahul Hackett"), findsAny);

    // Last person in the list, index = 19
    expect(find.widgetWithText(ListTile, "Maximus Torp"), findsNothing);
    bloc.add(LoadmorePersons(page: 2, limit: 20));
    await tester.pumpAndSettle();
    expect(tester.widgetList<ListView>(find.byType(ListTile)).length, 30);

    // Last person in the list, index = 19
    expect(find.widgetWithText(ListTile, "Maximus Torp"), findsAny);

    bloc.add(LoadmorePersons(page: 3, limit: 20));
    await tester.pumpAndSettle();
    expect(tester.widgetList<ListView>(find.byType(ListTile)).length, 50);
    expect(find.widgetWithText(ListTile, "Maximus Torp"), findsAny);

    bloc.add(LoadmorePersons(page: 4, limit: 20));
    await tester.pumpAndSettle();
    expect(tester.widgetList<ListView>(find.byType(ListTile)).length, 70);
  });

  testWidgets('Test widgets rendering with network error',
      (WidgetTester tester) async {
    when(httpClient
            .get(Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=20")))
        .thenThrow(Exception("Something went wrong"));
    when(httpClient
            .get(Uri.parse("https://fakerapi.it/api/v1/persons?_quantity=10")))
        .thenThrow(Exception("Something went wrong"));
    nock('https://fakerapi.it')
        .get('/api/v1/persons?_quantity=10')
        .throwNetworkError();

    nock('https://fakerapi.it')
        .get('/api/v1/persons?_quantity=20')
        .throwNetworkError();

    final bloc = PersonListBloc(personRepository: repository);
    await tester.pumpWidget(MyTestApp(bloc: bloc));

    expect(find.text('Person List'), findsOneWidget);
    expect(find.byType(PersonListWidget), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets("Test list item tapped and navigate to detail page",
      (tester) async {
    nock('https://fakerapi.it')
        .get('/api/v1/persons?_quantity=10')
        .reply(200, rawData);

    nock('https://fakerapi.it')
        .get('/api/v1/persons?_quantity=20')
        .reply(200, rawData);
    final bloc = PersonListBloc(personRepository: repository);
    await tester.pumpWidget(MyTestApp(bloc: bloc));

    expect(find.text('Person List'), findsOneWidget);
    expect(find.byType(PersonListWidget), findsOneWidget);
    await tester.pumpAndSettle();

    // First person in the list, index = 0
    expect(find.widgetWithText(ListTile, "Rahul Hackett"), findsAny);

    // Tap on the first ListTile
    await tester.tap(find.widgetWithText(ListTile, "Rahul Hackett"));
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Assert that the person details page is displayed
    expect(find.byType(PersonDetailPage), findsOneWidget);
    expect(find.text("Person Details"), findsOneWidget);

    // Assert that the tapped person's name is displayed
    expect(find.text("Name: Rahul Hackett"), findsOneWidget);

    // Tap on the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(Duration(seconds: 2));

    // Assert that the person list page is displayed
    expect(find.byType(PersonListPage), findsOneWidget);

    // Assert that the list view has 10 items
    expect(tester.widgetList<ListView>(find.byType(ListTile)).length, 10);
  });
}

class MyTestApp extends StatelessWidget {
  MyTestApp({super.key, required this.bloc});
  final PersonListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        RouteSettings routeSettings = settings;

        Widget page = BlocProvider.value(
          value: bloc..add(FetchPersons()),
          child: PersonListPage(),
        );

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
      },
    );
  }
}
