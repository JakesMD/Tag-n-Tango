import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tstorage_repository/storage_repository.dart';

part 'event.dart';
part 'state.dart';

/// {@template TTagPlaylistAdditionBloc}
///
/// BLoC responsible for handling the business logic of adding files to a tag
/// playlist.
///
/// {@endtemplate}
class TTagPlaylistAdditionBloc
    extends Bloc<_TTagPlaylistAdditionEvent, TTagPlaylistAdditionState> {
  /// {@macro TTagPlaylistAdditionBloc}
  TTagPlaylistAdditionBloc({required this.repository})
      : super(TTagPlaylistAdditionInitial()) {
    on<TTagPlaylistAdditionTriggered>(_onTriggered);
    on<_TTagPlaylistAdditionCompleted>(_onCompleted);
  }

  /// The repository this bloc will use for storage operations.
  final TStorageRepository repository;

  Future<void> _onTriggered(
    TTagPlaylistAdditionTriggered event,
    Emitter<TTagPlaylistAdditionState> emit,
  ) async {
    emit(TTagPlaylistAdditionInProgress());

    final result = await repository.addFilesToTagPlaylist(tag: event.tag);

    add(_TTagPlaylistAdditionCompleted(data: result));
  }

  void _onCompleted(
    _TTagPlaylistAdditionCompleted event,
    Emitter<TTagPlaylistAdditionState> emit,
  ) {
    emit(
      event.data.fold(
        (exception) => TTagPlaylistAdditionFailure(exception: exception),
        (_) => TTagPlaylistAdditionSuccess(),
      ),
    );
  }
}
