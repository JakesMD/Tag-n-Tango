part of 'bloc.dart';

/// States of the [TTagStreamBloc].
sealed class TTagStreamState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

/// Initial state of the [TTagStreamBloc]. Indicates that no tag has been beeped
/// yet.
final class TTagStreamInitial extends TTagStreamState {}

/// Indicates that the tag data has not loaded yet.
final class TTagStreamLoading extends TTagStreamState {}

/// Indicates that tag data was successfully streamed. Contains the streamed
/// [TTag] instance.
final class TTagStreamSuccess extends TTagStreamState {
  /// {@macro TTagStreamTagSuccess}
  TTagStreamSuccess({required this.tag});

  /// The [TTag] instance that was successfully streamed.
  final TTag tag;

  @override
  List<Object?> get props => [tag];
}

/// Indicates that an exception occurred while streaming tag data. Contains the
/// [TTagStreamException] that was thrown.
final class TTagStreamFailure extends TTagStreamState {
  /// {@macro TTagStreamFailure}
  TTagStreamFailure({required this.exception});

  /// The exception that occurred when streaming tag data.
  final TTagStreamException exception;

  @override
  List<Object?> get props => [exception];
}
