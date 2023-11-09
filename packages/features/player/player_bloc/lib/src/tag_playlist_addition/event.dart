part of 'bloc.dart';

sealed class _TTagPlaylistAdditionEvent {}

final class TTagPlaylistAdditionTriggered extends _TTagPlaylistAdditionEvent {
  /// {@macro TTagPlaylistAdditionTriggered}
  TTagPlaylistAdditionTriggered({required this.tag});

  final TTag tag;
}

final class _TTagPlaylistAdditionCompleted extends _TTagPlaylistAdditionEvent {
  _TTagPlaylistAdditionCompleted({required this.data});

  final Either<TTagPlaylistAdditionException, TTag> data;
}
