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
  TTagStreamBloc({
    required this.tagID,
    required this.repository,
  }) : super(TTagStreamLoading()) {
    _subscribeToTagStream();
    on<_TTagStreamUpdate>(_onUpdate);
  }

  /// The ID of the tag that this bloc is managing the stream for.
  final String tagID;

  /// The repository this bloc uses to get the tag stream.
  final TStorageRepository repository;

  late StreamSubscription<Either<TTagStreamException, TTag>> _tagSubscription;

  void _subscribeToTagStream() {
    _tagSubscription = repository.tagStream(tagID: tagID).listen(
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
  Future<void> close() {
    _tagSubscription.cancel();
    return super.close();
  }
}
