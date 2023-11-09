import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tplayer_bloc/player_bloc.dart';
import 'package:tstorage_repository/storage_repository.dart';

class MockTStorageRepository extends Mock implements TStorageRepository {}

void main() {
  group('TTagStreamBloc Tests', () {
    late StreamController<Either<TTagStreamException, TTag>> controller;
    late MockTStorageRepository repo;
    late TTagStreamBloc bloc;

    setUp(() {
      controller = StreamController()
        ..addStream(const Stream.empty()..asBroadcastStream());

      repo = MockTStorageRepository();
      when(() => repo.tagStream(tagID: '123')).thenAnswer(
        (_) => controller.stream,
      );

      bloc = TTagStreamBloc(repository: repo, tagID: '123');
    });

    test('''
        When: first initialized,
        Then: state is "loading"''', () {
      expect(bloc.state, TTagStreamLoading());
    });

    blocTest(
      '''
        When: client updates with tag ID,
        Then: emit "success" state with new tag''',
      build: () => bloc,
      act: (bloc) => controller.add(right(const TTag.empty(id: '123'))),
      expect: () => [TTagStreamSuccess(tag: const TTag.empty(id: '123'))],
    );

    blocTest(
      '''
        When: backend has error, Then: emit "failure" state''',
      build: () => bloc,
      act: (bloc) => controller.add(
        left(TTagStreamException.settingsLoadFailure),
      ),
      expect: () => [
        TTagStreamFailure(exception: TTagStreamException.settingsLoadFailure),
      ],
    );

    test('''
        When: bloc is no longer needed,
        Then: cancel subscription with client''', () async {
      await bloc.close();

      expect(controller.hasListener, false);
    });

    tearDown(() async {
      await bloc.close();
      await controller.close();
    });
  });
}
