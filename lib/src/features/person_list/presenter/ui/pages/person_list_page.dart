import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/blocs/person_list/person_list_bloc.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/widgets/person_list_widget.dart';

class PersonListPage extends StatelessWidget {
  static String get routeName {
    return "/PersonListPage";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Person List'),
            leading: kIsWeb
                ? IconButton(
                    onPressed: () {
                      context
                          .read<PersonListBloc>()
                          .add(FetchPersons(isRefresh: true));
                    },
                    icon: BlocBuilder<PersonListBloc, PersonListState>(
                        buildWhen: (previous, current) =>
                            previous.status == PersonListStatus.refreshing ||
                            current.status == PersonListStatus.refreshing,
                        builder: (context, state) {
                          return state.status == PersonListStatus.refreshing
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.refresh);
                        }))
                : SizedBox.shrink()),
        body: PersonListWidget());
  }
}
