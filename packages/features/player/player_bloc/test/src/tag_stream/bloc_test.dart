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
      repo = MockTStorageRepository();
      controller = StreamController();

      when(() => repo.tagStream(tagID: '123'))
          .thenAnswer((_) => controller.stream);

      bloc = TTagStreamBloc(repository: repo);
    });

    test('''
        When: first initialized,
        Then: state is "initial"''', () {
      expect(bloc.state, TTagStreamInitial());
    });

    blocTest(
      '''
        When: new tag added,
        Then: emit "loading" state''',
      build: () => bloc,
      act: (bloc) => bloc.add(TTagStreamNewTagBeeped(tagID: '123')),
      expect: () => [TTagStreamLoading()],
    );

    blocTest(
      '''
        When: client updates with tag ID,
        Then: emit "success" state with new tag''',
      build: () => bloc,
      act: (bloc) async {
        bloc.add(TTagStreamNewTagBeeped(tagID: '123'));
        await Future.delayed(Duration.zero);
        controller.add(right(const TTag.empty(id: '123')));
      },
      skip: 1,
      expect: () => [TTagStreamSuccess(tag: const TTag.empty(id: '123'))],
    );

    blocTest(
      '''
        When: backend has error, Then: emit "failure" state''',
      build: () => bloc,
      act: (bloc) async {
        bloc.add(TTagStreamNewTagBeeped(tagID: '123'));
        await Future.delayed(Duration.zero);
        controller.add(left(TTagStreamException.settingsLoadFailure));
      },
      skip: 1,
      expect: () => [
        TTagStreamFailure(exception: TTagStreamException.settingsLoadFailure),
      ],
    );

    test('''
        When: bloc is no longer needed,
        Then: cancel subscription with client''', () async {
      bloc.add(TTagStreamNewTagBeeped(tagID: '123'));
      await Future.delayed(Duration.zero);

      await bloc.close();

      expect(controller.hasListener, false);
    });

    tearDown(() async {
      await bloc.close();

      if (controller.hasListener) await controller.close();
    });
  });
}
