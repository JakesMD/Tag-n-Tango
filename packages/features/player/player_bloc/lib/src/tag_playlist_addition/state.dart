part of 'bloc.dart';

/// States of the [TTagPlaylistAdditionBloc].
sealed class TTagPlaylistAdditionState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

/// Initial state of the [TTagPlaylistAdditionBloc]. Indicates that no addition
/// has been triggered yet.
final class TTagPlaylistAdditionInitial extends TTagPlaylistAdditionState {}

/// Indicates that the process of adding files to a tag's playlist is currently
/// in progress.
final class TTagPlaylistAdditionInProgress extends TTagPlaylistAdditionState {}

/// Indicates that the process of adding files to a tag's playlist has
/// completed successfully.
final class TTagPlaylistAdditionSuccess extends TTagPlaylistAdditionState {}

/// {@template TTagPlaylistAdditionFailure}
///
/// Indicates that an exception occurred while adding files to a tag's playlist.
/// Contains the [TTagPlaylistAdditionException] that occurred.
///
/// {@endtemplate}
final class TTagPlaylistAdditionFailure extends TTagPlaylistAdditionState {
  /// {@macro TTagPlaylistAdditionFailure}
  TTagPlaylistAdditionFailure({required this.exception});

  /// The exception that occurred.
  final TTagPlaylistAdditionException exception;

  @override
  List<Object?> get props => [exception];
}
