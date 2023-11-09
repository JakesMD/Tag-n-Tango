part of 'bloc.dart';

sealed class _TTagPlaylistAdditionEvent {}

/// {@template TTagPlaylistAdditionTriggered}
///
/// Triggers the addition of files to a tag's playlist.
///
/// {@endtemplate}
final class TTagPlaylistAdditionTriggered extends _TTagPlaylistAdditionEvent {
  /// {@macro TTagPlaylistAdditionTriggered}
  TTagPlaylistAdditionTriggered({required this.tag});

  /// The tag to update.
  final TTag tag;
}

final class _TTagPlaylistAdditionCompleted extends _TTagPlaylistAdditionEvent {
  _TTagPlaylistAdditionCompleted({required this.data});

  final Either<TTagPlaylistAdditionException, TTag> data;
}
