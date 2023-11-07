import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcore/core.dart';
import 'package:tnfc_repository/nfc_repository.dart';
import 'package:tplayer_bloc/player_bloc.dart';

/// A page for testing purposes
class TTestPage extends StatelessWidget {
  /// {@macro TTestPage}
  const TTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TTagIDStreamBloc(
            repository: context.read<TNFCRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Test Page')),
        body: Center(
          child: TBlocBuilder<TTagIDStreamBloc, TTagIDStreamState>(
            builder: (context, bloc, state) => switch (state) {
              TTagIDStreamFailure() => const Icon(Icons.error_rounded),
              TTagIDStreamTagInitial() => const Text('No tag present'),
              TTagIDStreamTagBeeped(tagID: final tagID) =>
                Text('Tag ID: $tagID'),
            },
          ),
        ),
      ),
    );
  }
}
