part of 'person_detail_bloc.dart';

abstract class PersonDetailEvent extends Equatable {
  const PersonDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchPerson extends PersonDetailEvent {
  final int personId;

  FetchPerson(this.personId);

  @override
  List<Object?> get props => [personId];
}
