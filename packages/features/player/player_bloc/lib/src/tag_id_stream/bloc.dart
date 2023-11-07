import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tnfc_repository/nfc_repository.dart';

part 'event.dart';
part 'state.dart';

/// {@template TTagIDStreamBloc}
///
/// BLoC that manages the stream of NFC tag ID's from the repository. Converts
/// the stream of Either<Exception, String> into a stream of States.
///
/// {@endtemplate}
class TTagIDStreamBloc extends Bloc<_TTagIDStreamEvent, TTagIDStreamState> {
  /// {@macro TTagIDStreamBloc}
  TTagIDStreamBloc({required this.repository})
      : super(TTagIDStreamTagInitial()) {
    _subscribeToTagIDStream();
    on<_TTagIDStreamUpdate>(_onUpdate);
  }

  /// The TNFCRepository instance this bloc will use to subscribe to the NFC
  /// tag ID stream.
  final TNFCRepository repository;

  late StreamSubscription<Either<TTagIDStreamException, String>>
      _tagIDSubscription;

  void _subscribeToTagIDStream() {
    _tagIDSubscription = repository.tagIDStream().listen(
          (event) => add(_TTagIDStreamUpdate(data: event)),
        );
  }

  void _onUpdate(_TTagIDStreamUpdate event, Emitter<TTagIDStreamState> emit) {
    event.data.fold(
      (exception) => emit(TTagIDStreamFailure(exception: exception)),
      (tagID) => emit(TTagIDStreamTagBeeped(tagID: tagID)),
    );
  }

  @override
  Future<void> close() {
    _tagIDSubscription.cancel();
    return super.close();
  }
}
