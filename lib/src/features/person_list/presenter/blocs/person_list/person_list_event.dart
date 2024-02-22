part of 'person_list_bloc.dart';

abstract class PersonListEvent extends Equatable {
  final int limit;
  PersonListEvent({this.limit = 20});

  @override
  List<Object?> get props =>[limit];
}

class FetchPersons extends PersonListEvent {
  final bool isRefresh;

  FetchPersons({super.limit = 10, this.isRefresh = false});

  @override
  List<Object?> get props => [limit];
}


class LoadmorePersons extends PersonListEvent {
  final int page;
  final int limit;

  LoadmorePersons({required this.page, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}