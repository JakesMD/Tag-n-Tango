// coverage:ignore-file

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tstorage_client/storage_client.dart';

/// Client for interacting with local device storage.
///
/// Provides methods for copying audio files to local storage,
/// getting application storage directories, etc.
class TStorageClient {
  Directory? _appDirectory;

  Future<Directory> _getAppDirectory() async {
    return _appDirectory ??= await getApplicationDocumentsDirectory();
  }

  String _getFileName(File file) => file.path.split('/').last;

  /// Copies the given audio [sourceFiles] to the application's local storage
  /// directory under /audio.
  ///
  /// Returns a [List] of the copied [File] objects on success, or a
  /// [TFileCopyException] on failure.
  Future<Either<TFileCopyException, List<File>>> copyAudioFiles({
    required List<File> sourceFiles,
  }) async {
    try {
      final appDirectory = await _getAppDirectory();
      final destinationDirectory = Directory('${appDirectory.path}/audio/');
      await destinationDirectory.create(recursive: true);

      final copiedFiles = <File>[];

      for (final sourceFile in sourceFiles) {
        final destinationFile = File(
          '${destinationDirectory.path}/${_getFileName(sourceFile)}',
        );
        await destinationFile.writeAsBytes(await sourceFile.readAsBytes());

        copiedFiles.add(destinationFile);
      }

      return right(copiedFiles);
    } catch (exception) {
      return left(TFileCopyException.unknown);
    }
  }

  /// Deletes the File at the provided [filePath].
  ///
  /// Returns a [Right] with [Unit] if successful, or a [Left] with a
  /// [TFileDeletionException] if an error occurs.
  Future<Either<TFileDeletionException, Unit>> deleteFile({
    required String filePath,
  }) async {
    try {
      await File(filePath).delete();
      return right(unit);
    } catch (exception) {
      return left(TFileDeletionException.unknown);
    }
  }

  /// Loads the application settings from persistent storage.
  ///
  /// Returns a [Right] with the [TSettings] if successful, or a [Left] with a
  /// [TSettingsLoadException] if an error occurs.
  Future<Either<TSettingsLoadException, TSettings>> loadSettings() async {
    try {
      final appDirecory = await _getAppDirectory();
      final settingsFile = File('${appDirecory.path}/settings.json');

      // ignore: avoid_slow_async_io
      if (!await settingsFile.exists()) return right(const TSettings.empty());

      final json = jsonDecode(
        await settingsFile.readAsString(),
      ) as Map<String, dynamic>;

      return right(TSettings.fromJSON(json: json));
    } catch (exception) {
      return left(TSettingsLoadException.unknown);
    }
  }

  /// Saves the given [settings] to persistent storage.
  ///
  /// Returns a [Right] with [unit] if successful, or a [Left] with a
  /// [TSettingsSaveException] if an error occurs.
  Future<Either<TSettingsSaveException, Unit>> saveSettings({
    required TSettings settings,
  }) async {
    try {
      final appDirecory = await _getAppDirectory();
      final settingsFile = File('${appDirecory.path}/settings.json');

      await settingsFile.create();
      await settingsFile.writeAsString(jsonEncode(settings.toJSON()));

      return right(unit);
    } catch (exception) {
      return left(TSettingsSaveException.unknown);
    }
  }
}
