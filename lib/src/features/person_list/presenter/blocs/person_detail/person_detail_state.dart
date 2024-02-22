part of 'person_detail_bloc.dart';

abstract class PersonDetailState extends Equatable {
  const PersonDetailState();

  @override
  List<Object?> get props => [];
}

class PersonDetailInitial extends PersonDetailState {}

class PersonLoading extends PersonDetailState {}

class PersonFetched extends PersonDetailState{
  final Person person;

  PersonFetched(this.person);
  
  @override
  List<Object?> get props => [person];
}
