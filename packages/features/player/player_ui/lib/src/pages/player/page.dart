import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcore/core.dart';
import 'package:tnfc_repository/nfc_repository.dart';
import 'package:tplayer_bloc/player_bloc.dart';
import 'package:tplayer_ui/src/pages/player/views/_views.dart';

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
