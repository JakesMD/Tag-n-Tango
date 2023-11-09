part of 'bloc.dart';

/// States of the [TTagIDStreamBloc].
sealed class TTagIDStreamState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

/// Initial state of the [TTagIDStreamBloc]. Indicates that no tag has been read
/// yet.
final class TTagIDStreamTagInitial extends TTagIDStreamState {}

/// {@macro TTagIDStreamTagBeeped}
///
/// Indicates that a new tag ID has been read from the NFC stream. Contains the
/// tag ID string that was read.
///
/// {@endtemplate}
final class TTagIDStreamTagBeeped extends TTagIDStreamState {
  /// {@macro TTagIDStreamTagBeeped}
  TTagIDStreamTagBeeped({required this.tagID});

  /// The tag ID that was read from the NFC stream.
  final String tagID;

  @override
  List<Object?> get props => [tagID];
}

/// {@template TTagIDStreamFailure}
///
/// Indicates that an exception occurred while reading tag IDs from the NFC
/// stream. Contains the [TTagIDStreamException] that occurred.
///
/// {@endtemplate}
final class TTagIDStreamFailure extends TTagIDStreamState {
  /// {@macro TTagIDStreamFailure}
  TTagIDStreamFailure({required this.exception});

  /// The exception that occurred.
  final TTagIDStreamException exception;

  @override
  List<Object?> get props => [exception];
}
