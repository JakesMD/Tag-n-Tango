part of 'bloc.dart';

sealed class _TTagStreamEvent {}

final class _TTagStreamUpdate extends _TTagStreamEvent {
  _TTagStreamUpdate({required this.data});

  final Either<TTagStreamException, TTag> data;
}

/// {@template TTagStreamNewTagBeeped}
///
/// Notifies that a new tag has beeped. Contains the ID of the new tag.
///
/// {@endtemplate}
final class TTagStreamNewTagBeeped extends _TTagStreamEvent {
  /// {@macro TTagStreamNewTagBeeped}
  TTagStreamNewTagBeeped({required this.tagID});

  /// The ID of the tag that was beeped.
  final String tagID;
}
