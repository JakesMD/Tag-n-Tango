import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tnfc_repository/nfc_repository.dart';
import 'package:tplayer_bloc/player_bloc.dart';

class MockTNFCRepository extends Mock implements TNFCRepository {}

void main() {
  group('TTagIDStreamBloc Tests', () {
    late StreamController<Either<TTagIDStreamException, String>> controller;
    late MockTNFCRepository repo;
    late TTagIDStreamBloc bloc;

    setUp(() {
      controller = StreamController()
        ..addStream(const Stream.empty()..asBroadcastStream());

      repo = MockTNFCRepository();
      when(() => repo.tagIDStream()).thenAnswer((_) => controller.stream);

      bloc = TTagIDStreamBloc(repository: repo);
    });

    test('''
        When: first initialized,
        Then: state is "tag absent"''', () {
      expect(bloc.state, TTagIDStreamTagInitial());
    });

    blocTest(
      '''
        When: client updates with tag ID,
        Then: emit "tag present" state with new tag ID''',
      build: () => bloc,
      act: (bloc) => controller.add(right('123')),
      expect: () => [TTagIDStreamTagBeeped(tagID: '123')],
    );

    blocTest(
      '''
        When: backend has error, Then: emit "failure" state''',
      build: () => bloc,
      act: (bloc) => controller.add(left(TTagIDStreamException.unknown)),
      expect: () => [
        TTagIDStreamFailure(exception: TTagIDStreamException.unknown),
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
