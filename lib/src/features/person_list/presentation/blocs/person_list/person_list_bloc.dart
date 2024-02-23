import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/repositories/person_repository.dart';
import 'package:injectable/injectable.dart';

part 'person_list_event.dart';
part 'person_list_state.dart';

class PersonListBloc extends Bloc<PersonListEvent, PersonListState> {
  final PersonRepository personRepository;

  PersonListBloc({@injectable required this.personRepository})
      : super(PersonListState.initial()) {
    on<FetchPersons>(((event, emit) async {
      try {
        emit(state.copyWith(
            status: event.isRefresh
                ? PersonListStatus.refreshing
                : PersonListStatus.fetching));
        List<Person> persons = await _loadPersonsFromRepository(limit: event.limit);
        emit(state.copyWith(
            status: PersonListStatus.loaded,
            personList: persons,
            currentPage: 1,
            hasReachedEnd: false));
      } catch (_) {
        emit(state.copyWith(status: PersonListStatus.error));
      }
    }));

    on<LoadmorePersons>(((event, emit) async {
      try {
        emit(state.copyWith(status: PersonListStatus.loadingMore));
        List<Person> persons =
            await _loadPersonsFromRepository(limit: event.limit);
        emit(state.copyWith(
            status: PersonListStatus.loaded,
            personList: [...state.personList, ...persons],
            currentPage: event.page,
            hasReachedEnd: event.page == 4));
      } catch (_) {
        emit(state.copyWith(status: PersonListStatus.error));
      }
    }), transformer: droppable());
  }

  Future<List<Person>> _loadPersonsFromRepository({int limit = 20}) async {
    return personRepository.fetchPersons(limit: limit);
  }
}
