part of 'bloc.dart';

/// States of the [TTagPlaylistDeletionBloc].
sealed class TTagPlaylistDeletionState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

/// Initial state of the [TTagPlaylistDeletionBloc]. Indicates that no deletion
/// has been triggered yet.
final class TTagPlaylistDeletionInitial extends TTagPlaylistDeletionState {}

/// Indicates that the process of deleting a file from a tag's playlist is
/// currently in progress.
final class TTagPlaylistDeletionInProgress extends TTagPlaylistDeletionState {}

/// Indicates that the process of deleting a file from a tag's playlist has
/// completed successfully.
final class TTagPlaylistDeletionSuccess extends TTagPlaylistDeletionState {}

/// {@template TTagPlaylistDeletionFailure}
///
/// Indicates that an exception occurred while deleting a file from a tag's
/// playlist. Contains the [TTagPlaylistDeletionException] that was thrown.
///
/// {@endtemplate}
final class TTagPlaylistDeletionFailure extends TTagPlaylistDeletionState {
  /// {@macro TTagPlaylistDeletionFailure}
  TTagPlaylistDeletionFailure({required this.exception});

  /// The exception that occurred.
  final TTagPlaylistDeletionException exception;
}
