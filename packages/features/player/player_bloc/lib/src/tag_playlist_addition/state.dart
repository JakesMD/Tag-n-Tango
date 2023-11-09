part of 'bloc.dart';

sealed class TTagPlaylistAdditionState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class TTagPlaylistAdditionInitial extends TTagPlaylistAdditionState {}

final class TTagPlaylistAdditionInProgress extends TTagPlaylistAdditionState {}

final class TTagPlaylistAdditionSuccess extends TTagPlaylistAdditionState {}

final class TTagPlaylistAdditionFailure extends TTagPlaylistAdditionState {
  /// {@macro TTagPlaylistAdditionFailure}
  TTagPlaylistAdditionFailure({required this.exception});

  final TTagPlaylistAdditionException exception;
}
