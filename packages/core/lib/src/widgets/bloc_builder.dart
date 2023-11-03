import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template BBlocBuilder}
///
/// An extension on [BlocBuilder] that provides the bloc directly within the
/// builder function, simplifying the widget tree.
///
/// {@endtemplate}
class BBlocBuilder<B extends StateStreamable<S>, S> extends BlocBuilder<B, S> {
  /// {@macro BBlocBuilder}
  BBlocBuilder({
    required Widget Function(
      BuildContext context,
      B bloc,
      S state,
    ) builder,
    super.key,
    super.bloc,
    super.buildWhen,
  }) : super(
          builder: (context, state) {
            final newBloc = bloc ?? context.read<B>();
            return builder(context, newBloc, state);
          },
        );
}
