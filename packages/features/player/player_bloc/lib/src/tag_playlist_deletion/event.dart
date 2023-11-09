part of 'bloc.dart';

sealed class _TTagPlaylistDeletionEvent {}

/// {@template TTagPlaylistDeletionTriggered}
///
/// Triggers the deletion of a file from a tag's playlist.
///
/// {@endtemplate}
final class TTagPlaylistDeletionTriggered extends _TTagPlaylistDeletionEvent {
  /// {@macro TTagPlaylistDeletionTriggered}
  TTagPlaylistDeletionTriggered({required this.tag, required this.filePath});

  /// The tag to update.
  final TTag tag;

  /// The path of the file to delete from the tag's playlist.
  final String filePath;
}

final class _TTagPlaylistDeletionCompleted extends _TTagPlaylistDeletionEvent {
  _TTagPlaylistDeletionCompleted({required this.data});

  final Either<TTagPlaylistDeletionException, TTag> data;
}
