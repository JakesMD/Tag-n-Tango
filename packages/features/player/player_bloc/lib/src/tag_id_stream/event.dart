part of 'bloc.dart';

sealed class _TTagIDStreamEvent {}

final class _TTagIDStreamUpdate extends _TTagIDStreamEvent {
  _TTagIDStreamUpdate({required this.data});

  final Either<TTagIDStreamException, String> data;
}
