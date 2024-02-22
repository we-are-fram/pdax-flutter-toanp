import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';

part "person_detail_event.dart";
part "person_detail_state.dart";


class PersonDetailBloc extends Bloc<PersonDetailEvent, PersonDetailState> {
  PersonDetailBloc() : super(PersonDetailInitial()){
    on<FetchPerson>((event, emit) {
      emit(PersonLoading());
      // final person = Person(id: event.personId, name: "Person ${event.personId}");
      // emit(PersonFetched(event.person));
    });
  }
}
