import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/blocs/person_list/person_list_bloc.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/pages/person_detail_page.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presenter/ui/widgets/person_avatar.dart';

class PersonListWidget extends StatefulWidget {
  const PersonListWidget({super.key});

  @override
  State<PersonListWidget> createState() => _PersonListWidgetState();
}

class _PersonListWidgetState extends State<PersonListWidget> {
  Completer<void>? _refreshCompleter = Completer<void>();

  @override
  void dispose() {
    super.dispose();
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      _refreshCompleter!.complete();
    }
    _refreshCompleter = null;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        final state = context.read<PersonListBloc>().state;
        if (state.hasReachedEnd || kIsWeb || state.status == PersonListStatus.loadingMore) return true;
        return _onLoadmore(
            context, scrollInfo, state.currentPage, state.personList.length);
      },
      child: RefreshIndicator(
        onRefresh: () {
          context.read<PersonListBloc>().add(FetchPersons(isRefresh: true));
          _refreshCompleter = Completer();
          return _refreshCompleter!.future;
        },
        child: ListView(
          children: [
            _listItems(context),
            _listFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _listItems(BuildContext context) {
    return BlocConsumer<PersonListBloc, PersonListState>(
        listener: (context, state) {
      if (state.status == PersonListStatus.loaded &&
          _refreshCompleter != null &&
          !_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete();
      }
    }, builder: (context, state) {
      return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.personList.length,
        itemBuilder: (context, index) {
          Person person = state.personList[index];
          return ListTile(
            key: Key("${person.id}"),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(PersonDetailPage.routeName, arguments: person);
            },
            leading: PersonAvatar(image: person.image),
            title: Text(person.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(person.email),
          );
        },
      );
    });
  }

  Widget _listFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<PersonListBloc, PersonListState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.hasReachedEnd != current.hasReachedEnd,
        builder: (context, state) {
          if (state.hasReachedEnd) {
            return Center(
              child: Text('You have reached the end!',
                  style: TextStyle(
                      fontSize: kIsWeb ? 20 : 14, fontWeight: FontWeight.bold)),
            );
          }

          if (state.status == PersonListStatus.loadingMore ||
              state.status == PersonListStatus.fetching) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (kIsWeb && state.status == PersonListStatus.loaded) {
            return ElevatedButton(
              onPressed: () {
                context.read<PersonListBloc>().add(
                    LoadmorePersons(page: state.currentPage + 1, limit: 20));
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Load more', style: TextStyle(fontSize: 20)),
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  bool _onLoadmore(BuildContext context, ScrollNotification scrollInfo,
      int currentPage, int limit) {
      
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
      context
          .read<PersonListBloc>()
          .add(LoadmorePersons(page: currentPage + 1, limit: limit));
    }
    return true;
  }
}
