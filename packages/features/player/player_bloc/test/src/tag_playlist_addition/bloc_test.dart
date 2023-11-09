import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tplayer_bloc/player_bloc.dart';
import 'package:tstorage_repository/storage_repository.dart';

class MockTStorageRepository extends Mock implements TStorageRepository {}

void main() {
  group('TTagPlaylistAddition Tests', () {
    const someTag = TTag.empty(id: '123');
    late MockTStorageRepository repo;
    late TTagPlaylistAdditionBloc bloc;

    setUp(() {
      repo = MockTStorageRepository();
      bloc = TTagPlaylistAdditionBloc(repository: repo);
    });

    test('''
      When: first initialized,
      Then: state is "initial"''', () {
      expect(bloc.state, TTagPlaylistAdditionInitial());
    });

    blocTest(
      '''
      When: triggered,
      Then: state is "in progress"''',
      setUp: () => when(() => repo.addFilesToTagPlaylist(tag: someTag))
          .thenAnswer((_) async => right(someTag)),
      build: () => bloc,
      act: (bloc) => bloc.add(TTagPlaylistAdditionTriggered(tag: someTag)),
      expect: () => [
        TTagPlaylistAdditionInProgress(),
        isA<TTagPlaylistAdditionState>(),
      ],
    );

    blocTest(
      '''
      Given: client has success,
      When: triggered,
      Then: state is "success"''',
      setUp: () => when(() => repo.addFilesToTagPlaylist(tag: someTag))
          .thenAnswer((_) async => right(someTag)),
      build: () => bloc,
      act: (bloc) => bloc.add(TTagPlaylistAdditionTriggered(tag: someTag)),
      skip: 1,
      expect: () => [TTagPlaylistAdditionSuccess()],
    );

    blocTest(
      '''
      Given: client has failure,
      When: triggered,
      Then: state is "failure"''',
      setUp: () =>
          when(() => repo.addFilesToTagPlaylist(tag: someTag)).thenAnswer(
        (_) async => left(TTagPlaylistAdditionException.fileCopyFailure),
      ),
      build: () => bloc,
      act: (bloc) => bloc.add(TTagPlaylistAdditionTriggered(tag: someTag)),
      skip: 1,
      expect: () => [
        TTagPlaylistAdditionFailure(
          exception: TTagPlaylistAdditionException.fileCopyFailure,
        ),
      ],
    );
  });
}
