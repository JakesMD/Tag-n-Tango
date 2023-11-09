import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tstorage_repository/storage_repository.dart';

part 'event.dart';
part 'state.dart';

/// {@template TTagPlaylistDeletionBloc}
///
/// BLoC responsible for handling the business logic of deleting files from a
/// tag playlist.
///
/// {@endtemplate}
class TTagPlaylistDeletionBloc
    extends Bloc<_TTagPlaylistDeletionEvent, TTagPlaylistDeletionState> {
  /// {@macro TTagPlaylistDeletionBloc}
  TTagPlaylistDeletionBloc({required this.repository})
      : super(TTagPlaylistDeletionInitial()) {
    on<TTagPlaylistDeletionTriggered>(_onTriggered);
    on<_TTagPlaylistDeletionCompleted>(_onCompleted);
  }

  /// The repository this bloc will use for storage operations.
  final TStorageRepository repository;

  Future<void> _onTriggered(
    TTagPlaylistDeletionTriggered event,
    Emitter<TTagPlaylistDeletionState> emit,
  ) async {
    emit(TTagPlaylistDeletionInProgress());

    final result = await repository.deleteFileFromTagPlaylist(
      tag: event.tag,
      filePath: event.filePath,
    );

    add(_TTagPlaylistDeletionCompleted(data: result));
  }

  void _onCompleted(
    _TTagPlaylistDeletionCompleted event,
    Emitter<TTagPlaylistDeletionState> emit,
  ) {
    emit(
      event.data.fold(
        (exception) => TTagPlaylistDeletionFailure(exception: exception),
        (_) => TTagPlaylistDeletionSuccess(),
      ),
    );
  }
}
