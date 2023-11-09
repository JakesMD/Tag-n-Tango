import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcore/core.dart';
import 'package:tplayer_bloc/player_bloc.dart';
import 'package:tstorage_repository/storage_repository.dart';

class TPlayerTagView extends StatelessWidget {
  /// {@macro TPlayerTagView}
  const TPlayerTagView({
    required this.tagID,
    super.key,
  });

  final String tagID;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TTagStreamBloc(
            tagID: tagID,
            repository: context.read<TStorageRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(tagID)),
        body: TBlocBuilder<TTagStreamBloc, TTagStreamState>(
          builder: (context, bloc, state) => switch (state) {
            TTagStreamLoading() => const LinearProgressIndicator(),
            TTagStreamFailure() => const Text('Error'),
            TTagStreamSuccess(tag: final tag) => ListView(
                children: tag.playlist
                    .map((song) => ListTile(title: Text(song)))
                    .toList(),
              ),
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
