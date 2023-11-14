import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tstorage_repository/storage_repository.dart';

part 'event.dart';
part 'state.dart';

/// {@template TTagStreamBloc}
///
/// BLoC that manages the stream of NFC tag data from the repository. Converts
/// the stream of Either<Exception, TTag> into a stream of States.
///
/// {@endtemplate}
class TTagStreamBloc extends Bloc<_TTagStreamEvent, TTagStreamState> {
  /// {@macro TTagStreamBloc}
  TTagStreamBloc({required this.repository}) : super(TTagStreamInitial()) {
    on<_TTagStreamUpdate>(_onUpdate);
    on<TTagStreamNewTagBeeped>(_onNewTagBeeped);
  }

  /// The repository this bloc uses to get the tag stream.
  final TStorageRepository repository;

  StreamSubscription<Either<TTagStreamException, TTag>>? _tagSubscription;

  Future<void> _onNewTagBeeped(
    TTagStreamNewTagBeeped event,
    Emitter<TTagStreamState> emit,
  ) async {
    emit(TTagStreamLoading());

    await _tagSubscription?.cancel();

    _tagSubscription = repository.tagStream(tagID: event.tagID).listen(
          (event) => add(_TTagStreamUpdate(data: event)),
        );
  }

  void _onUpdate(_TTagStreamUpdate event, Emitter<TTagStreamState> emit) {
    event.data.fold(
      (exception) => emit(TTagStreamFailure(exception: exception)),
      (tag) => emit(TTagStreamSuccess(tag: tag)),
    );
  }

  @override
  Future<void> close() async {
    await _tagSubscription?.cancel();
    return super.close();
  }
}
