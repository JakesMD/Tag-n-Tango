import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcore/core.dart';
import 'package:tnfc_repository/nfc_repository.dart';
import 'package:tplayer_bloc/player_bloc.dart';
import 'package:tplayer_ui/src/pages/player/views/_views.dart';
import 'package:tstorage_repository/storage_repository.dart';

/// {@macro TPlayerPage}
///
/// The main page for the player feature.
///
/// This widget is the root page of the player feature. It provides the app
/// scaffolding and initializes the bloc providers needed for the player to
/// function.
///
/// {@endtemplate}
class TPlayerPage extends StatelessWidget {
  /// {@macro TPlayerPage}
  const TPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TTagIDStreamBloc(
            repository: context.read<TNFCRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TTagStreamBloc(
            repository: context.read<TStorageRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TTagPlaylistAdditionBloc(
            repository: context.read<TStorageRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TTagPlaylistDeletionBloc(
            repository: context.read<TStorageRepository>(),
          ),
        ),
      ],
      child: TBlocBuilder<TTagIDStreamBloc, TTagIDStreamState>(
        builder: (context, bloc, state) => switch (state) {
          TTagIDStreamFailure() => const TPlayerFailureView(),
          TTagIDStreamTagInitial() => const TPlayerNoTagView(),
          TTagIDStreamTagBeeped(tagID: final tagID) =>
            TPlayerTagView(tagID: tagID)
        },
      ),
    );
  }
}
