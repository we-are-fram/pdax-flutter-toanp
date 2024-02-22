part of 'person_list_bloc.dart';

enum PersonListStatus { initial, fetching, loadingMore, refreshing, loaded, error }

class PersonListState {
  final PersonListStatus status;
  final List<Person> personList;
  final bool hasReachedEnd;
  final bool loadingMore;
  final int currentPage;

  PersonListState({
    required this.status,
    this.personList = const <Person>[],
    this.hasReachedEnd = false,
    this.loadingMore = false,
    this.currentPage = 1
  });

  factory PersonListState.initial() {
    return PersonListState(
      status: PersonListStatus.initial,
    );
  }

  PersonListState copyWith({
    PersonListStatus? status,
    List<Person>? personList,
    bool? hasReachedEnd,
    bool? loadingMore,
    int? currentPage
  }) {
    return PersonListState(
      status: status ?? this.status,
      personList: personList ?? this.personList,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      loadingMore: loadingMore ?? this.loadingMore,
      currentPage: currentPage ?? this.currentPage
    );
  }
}
