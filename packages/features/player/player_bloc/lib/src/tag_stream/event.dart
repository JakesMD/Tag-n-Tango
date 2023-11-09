part of 'bloc.dart';

sealed class _TTagStreamEvent {}

final class _TTagStreamUpdate extends _TTagStreamEvent {
  _TTagStreamUpdate({required this.data});

  final Either<TTagStreamException, TTag> data;
}
