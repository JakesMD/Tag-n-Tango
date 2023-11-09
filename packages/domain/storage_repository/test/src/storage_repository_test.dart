import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tfile_picker_client/file_picker_client.dart';
import 'package:tstorage_client/storage_client.dart';
import 'package:tstorage_repository/storage_repository.dart';

class MockTStorageClient extends Mock implements TStorageClient {}

class MockTFilePickerClient extends Mock implements TFilePickerClient {}

void main() {
  group('TStorageRepository Tests', () {
    late MockTStorageClient storageClient;
    late MockTFilePickerClient filePickerClient;
    late TStorageRepository storageRepository;

    setUp(() {
      storageClient = MockTStorageClient();
      filePickerClient = MockTFilePickerClient();
      storageRepository = TStorageRepository(
        storageClient: storageClient,
        filePickerClient: filePickerClient,
      );
    });

    group('fetchTag Tests', () {
      test('''
      Given: storage client has failure,
      When: fetch tag,
      Then: returns "settings load failure"''', () async {
        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => left(TSettingsLoadException.unknown),
        );

        final result = await storageRepository.fetchTag(tagID: '');

        expect(result, left(TTagFetchException.settingsLoadFailure));
      });

      test('''
      Given: storage client has success but tag not registered,
      When: fetch tag,
      Then: returns empty tag with given ID''', () async {
        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(const TSettings.empty()),
        );

        final result = await storageRepository.fetchTag(tagID: '123');

        expect(result, right(const TTag.empty(id: '123')));
      });

      test('''
      Given: storage client has success and tag registered,
      When: fetch tag,
      Then: returns tag with given ID''', () async {
        final matcher = const TTag.empty(id: '123').copyWith(
          playlist: {'someFilePath'},
        );
        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(const TSettings.empty().copyWith(tags: {matcher})),
        );

        final result = await storageRepository.fetchTag(tagID: '123');

        expect(result, right(matcher));
      });
    });

    group('deleteFileFromTagPlaylist Tests', () {
      test('''
      Given: storage client has failure,
      When: delete file from playlist,
      Then: returns "settings load failure"''', () async {
        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => left(TSettingsLoadException.unknown),
        );

        final result = await storageRepository.addFilesToTagPlaylist(
          tag: const TTag.empty(id: '123'),
        );

        expect(result, left(TTagPlaylistAdditionException.settingsLoadFailure));
      });

      test('''
      Given: file picker has failure,
      When: add files to tag playlist,
      Then: returns "file pick failure"''', () async {
        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(const TSettings.empty()),
        );
        when(() => filePickerClient.pickAudioFiles()).thenAnswer(
          (_) async => left(TFilePickException.unknown),
        );

        final result = await storageRepository.addFilesToTagPlaylist(
          tag: const TTag.empty(id: '123'),
        );

        expect(result, left(TTagPlaylistAdditionException.filePickFailure));
      });
      test('''
      Given: file copy has failure,
      When: add files to tag playlist,
      Then: returns "file copy failure"''', () async {
        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(const TSettings.empty()),
        );
        when(() => filePickerClient.pickAudioFiles()).thenAnswer(
          (_) async => right([File('someFilePath')]),
        );
        when(
          () => storageClient.copyAudioFiles(
            sourceFiles: any(named: 'sourceFiles'),
          ),
        ).thenAnswer((_) async => left(TFileCopyException.unknown));

        final result = await storageRepository.addFilesToTagPlaylist(
          tag: const TTag.empty(id: '123'),
        );

        expect(result, left(TTagPlaylistAdditionException.fileCopyFailure));
      });

      test('''
      Given: save settings has failure,
      When: add files to tag playlist,
      Then: returns "settings save failure"''', () async {
        final files = [File('someFilePath')];
        const settings = TSettings.empty();

        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(settings),
        );
        when(() => filePickerClient.pickAudioFiles()).thenAnswer(
          (_) async => right(files),
        );
        when(
          () => storageClient.copyAudioFiles(
            sourceFiles: any(named: 'sourceFiles'),
          ),
        ).thenAnswer((_) async => right(files));
        when(
          () => storageClient.saveSettings(
            settings: settings.copyWith(
              tags: {
                TTag(
                  id: '123',
                  playlist: files.map((file) => file.path).toSet(),
                ),
              },
            ),
          ),
        ).thenAnswer((_) async => left(TSettingsSaveException.unknown));

        final result = await storageRepository.addFilesToTagPlaylist(
          tag: const TTag.empty(id: '123'),
        );

        expect(result, left(TTagPlaylistAdditionException.settingsSaveFailure));
      });

      test('''
      Given: all clients have success and tag is registered,
      When: add files to tag playlist,
      Then: returns the updated tag''', () async {
        final files = [File('someFilePath')];
        const originalTag = TTag.empty(id: '123');
        final matcher = TTag(
          id: '123',
          playlist: files.map((file) => file.path).toSet(),
        );
        final settings = const TSettings.empty().copyWith(tags: {originalTag});

        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(settings),
        );
        when(() => filePickerClient.pickAudioFiles()).thenAnswer(
          (_) async => right(files),
        );
        when(
          () => storageClient.copyAudioFiles(
            sourceFiles: any(named: 'sourceFiles'),
          ),
        ).thenAnswer((_) async => right(files));
        when(
          () => storageClient.saveSettings(
            settings: settings.copyWith(tags: {matcher}),
          ),
        ).thenAnswer((_) async => right(unit));

        final result = await storageRepository.addFilesToTagPlaylist(
          tag: originalTag,
        );

        expect(result, right(matcher));
      });
    });

    group('addFilesToTagPlaylist Tests', () {
      test('''
      Given: fetch settings has failure,
      When: delete file from playlist,
      Then: returns "settings load failure"''', () async {
        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => left(TSettingsLoadException.unknown),
        );

        final result = await storageRepository.deleteFileFromTagPlaylist(
          tag: const TTag.empty(id: '123'),
          filePath: 'someFilePath',
        );

        expect(result, left(TTagPlaylistDeletionException.settingsLoadFailure));
      });

      test('''
      Given: delete has failure,
      When: delete file from playlist,
      Then: returns "file deletion failure"''', () async {
        const filePath = 'someFilePath';

        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(const TSettings.empty()),
        );
        when(() => storageClient.deleteFile(filePath: filePath)).thenAnswer(
          (_) async => left(TFileDeletionException.unknown),
        );

        final result = await storageRepository.deleteFileFromTagPlaylist(
          tag: const TTag.empty(id: '123'),
          filePath: filePath,
        );

        expect(result, left(TTagPlaylistDeletionException.fileDeletionFailure));
      });

      test('''
      Given: multiple tag have same file in playlist,
      When: delete file from playlist,
      Then: doesn't call delete file''', () async {
        const filePath = 'someFilePath';
        final tag = const TTag.empty(id: '123').copyWith(playlist: {filePath});
        final otherTag = const TTag.empty(id: '456').copyWith(
          playlist: {filePath},
        );

        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(
            const TSettings.empty().copyWith(tags: {tag, otherTag}),
          ),
        );
        when(() => storageClient.deleteFile(filePath: filePath)).thenAnswer(
          (_) async => right(unit),
        );
        when(
          () => storageClient.saveSettings(
            settings: const TSettings.empty().copyWith(
              tags: {tag.copyWith(playlist: {}), otherTag},
            ),
          ),
        ).thenAnswer((_) async => left(TSettingsSaveException.unknown));

        await storageRepository.deleteFileFromTagPlaylist(
          tag: tag,
          filePath: filePath,
        );

        verifyNever(() => storageClient.deleteFile(filePath: filePath));
      });

      test('''
      Given: save settings has failure,
      When: delete file from playlist,
      Then: returns "settings save failure"''', () async {
        const filePath = 'someFilePath';
        final tag = const TTag.empty(id: '123').copyWith(playlist: {filePath});

        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(
            const TSettings.empty().copyWith(tags: {tag}),
          ),
        );
        when(() => storageClient.deleteFile(filePath: filePath)).thenAnswer(
          (_) async => right(unit),
        );
        when(
          () => storageClient.saveSettings(
            settings: const TSettings.empty().copyWith(
              tags: {tag.copyWith(playlist: {})},
            ),
          ),
        ).thenAnswer((_) async => left(TSettingsSaveException.unknown));

        final result = await storageRepository.deleteFileFromTagPlaylist(
          tag: tag,
          filePath: filePath,
        );

        expect(result, left(TTagPlaylistDeletionException.settingsSaveFailure));
      });

      test('''
      Given: all clients have success,
      When: delete file from playlist,
      Then: returns updated tag''', () async {
        const filePath = 'someFilePath';
        final tag = const TTag.empty(id: '123').copyWith(playlist: {filePath});
        final matcher = tag.copyWith(playlist: {});

        when(() => storageClient.loadSettings()).thenAnswer(
          (_) async => right(
            const TSettings.empty().copyWith(tags: {tag}),
          ),
        );
        when(() => storageClient.deleteFile(filePath: filePath)).thenAnswer(
          (_) async => right(unit),
        );
        when(
          () => storageClient.saveSettings(
            settings: const TSettings.empty().copyWith(
              tags: {matcher},
            ),
          ),
        ).thenAnswer((_) async => right(unit));

        final result = await storageRepository.deleteFileFromTagPlaylist(
          tag: tag,
          filePath: filePath,
        );

        expect(result, right(matcher));
      });
    });
  });
}
