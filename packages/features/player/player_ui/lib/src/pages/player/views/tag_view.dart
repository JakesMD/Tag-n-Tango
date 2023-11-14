import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcore/core.dart';
import 'package:tplayer_bloc/player_bloc.dart';
import 'package:tplayer_ui/src/pages/player/views/_views.dart';

/// {@template TPlayerTagView}
///
/// Displays the data for a specific tag.
///
/// {@endtemplate}
class TPlayerTagView extends StatelessWidget {
  /// {@macro TPlayerTagView}
  const TPlayerTagView({
    required this.tagID,
    super.key,
  });

  /// The ID of the tag to display data for.
  final String tagID;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TTagIDStreamBloc, TTagIDStreamState>(
      listener: (context, state) => context.read<TTagStreamBloc>().add(
            TTagStreamNewTagBeeped(
              tagID: (state as TTagIDStreamTagBeeped).tagID,
            ),
          ),
      listenWhen: (_, state) => state is TTagIDStreamTagBeeped,
      child: TBlocBuilder<TTagStreamBloc, TTagStreamState>(
        builder: (context, bloc, state) => switch (state) {
          TTagStreamInitial() => const TPlayerLoadingView(),
          TTagStreamLoading() => const TPlayerLoadingView(),
          TTagStreamFailure() => const TPlayerFailureView(),
          TTagStreamSuccess(tag: final tag) => Scaffold(
              appBar: AppBar(title: Text(tag.id)),
              body: ListView(
                children: tag.playlist
                    .map(
                      (song) => ListTile(
                        title: Text(song),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_rounded),
                          onPressed: () {},
                        ),
                      ),
                    )
                    .toList(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => context.read<TTagPlaylistAdditionBloc>().add(
                      TTagPlaylistAdditionTriggered(tag: tag),
                    ),
                child: const Icon(Icons.add_rounded),
              ),
            ),
        },
      ),
    );
  }
}
