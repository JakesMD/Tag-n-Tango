import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tplayer_bloc/player_bloc.dart';
import 'package:tstorage_repository/storage_repository.dart';

class MockTStorageRepository extends Mock implements TStorageRepository {}

void main() {
  group('TTagPlaylistDeletion Tests', () {
    const someTag = TTag.empty(id: '123');
    const someFilePath = 'someFilePath';

    late MockTStorageRepository repo;
    late TTagPlaylistDeletionBloc bloc;

    setUp(() {
      repo = MockTStorageRepository();
      bloc = TTagPlaylistDeletionBloc(repository: repo);
    });

    test('''
      When: first initialized,
      Then: state is "initial"''', () {
      expect(bloc.state, TTagPlaylistDeletionInitial());
    });

    blocTest(
      '''
      When: triggered,
      Then: state is "in progress"''',
      setUp: () => when(
        () => repo.deleteFileFromTagPlaylist(
          tag: someTag,
          filePath: someFilePath,
        ),
      ).thenAnswer((_) async => right(someTag)),
      build: () => bloc,
      act: (bloc) => bloc.add(
        TTagPlaylistDeletionTriggered(tag: someTag, filePath: someFilePath),
      ),
      expect: () => [
        TTagPlaylistDeletionInProgress(),
        isA<TTagPlaylistDeletionState>(),
      ],
    );

    blocTest(
      '''
      Given: client has success,
      When: triggered,
      Then: state is "success"''',
      setUp: () => when(
        () => repo.deleteFileFromTagPlaylist(
          tag: someTag,
          filePath: someFilePath,
        ),
      ).thenAnswer((_) async => right(someTag)),
      build: () => bloc,
      act: (bloc) => bloc.add(
        TTagPlaylistDeletionTriggered(tag: someTag, filePath: someFilePath),
      ),
      skip: 1,
      expect: () => [TTagPlaylistDeletionSuccess()],
    );

    blocTest(
      '''
      Given: client has failure,
      When: triggered,
      Then: state is "failure"''',
      setUp: () => when(
        () => repo.deleteFileFromTagPlaylist(
          tag: someTag,
          filePath: someFilePath,
        ),
      ).thenAnswer(
        (_) async => left(TTagPlaylistDeletionException.fileDeletionFailure),
      ),
      build: () => bloc,
      act: (bloc) => bloc.add(
        TTagPlaylistDeletionTriggered(tag: someTag, filePath: someFilePath),
      ),
      skip: 1,
      expect: () => [
        TTagPlaylistDeletionFailure(
          exception: TTagPlaylistDeletionException.fileDeletionFailure,
        ),
      ],
    );
  });
}
