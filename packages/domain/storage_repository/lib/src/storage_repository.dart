import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:rxdart/subjects.dart';
import 'package:tcore/core.dart';
import 'package:tfile_picker_client/file_picker_client.dart';
import 'package:tstorage_client/storage_client.dart';
import 'package:tstorage_repository/storage_repository.dart';

export 'package:tstorage_client/storage_client.dart'
    show TSettings, TSettingsLoadException, TTag;

/// {@template TStorageRepository}
///
/// The storage repository provides an interface for loading and saving tag
/// settings, as well as selecting playlist files.
///
/// {@endtemplate}
class TStorageRepository {
  /// {@macro TStorageRepository}
  TStorageRepository({
    required this.storageClient,
    required this.filePickerClient,
  });

  /// The storage client used for loading and saving settings.
  final TStorageClient storageClient;

  /// The file picker client used for selecting playlist files.
  final TFilePickerClient filePickerClient;

  final _settings = BehaviorSubject<TSettings>();

  Future<Either<TSettingsSaveException, Unit>> _saveSettings(
    TSettings settings,
  ) async {
    final result = await storageClient.saveSettings(settings: settings);

    return result.fold(
      left,
      (_) {
        _settings.value = settings;
        return right(unit);
      },
    );
  }

  Future<Either<TSettingsLoadException, TSettings>> _fetchSettings() async {
    if (!_settings.hasValue) {
      final result = await storageClient.loadSettings();
      return result.fold(left, (settings) {
        _settings.value = settings;
        return right(settings);
      });
    }

    return right(_settings.value); // coverage:ignore-line
  }

  /// Streams the tag with the given [tagID] from the stored settings.
  ///
  /// If no match is found, yields an empty tag with that [tagID].
  ///
  /// Yields a [TTagStreamException] on failure and the queried [TTag] on
  /// success.
  Stream<Either<TTagStreamException, TTag>> tagStream({
    required String tagID,
  }) async* {
    final result = await _fetchSettings();

    if (result.isLeft()) {
      yield left(
        switch (result.tAsLeft()) {
          TSettingsLoadException.unknown =>
            TTagStreamException.settingsLoadFailure,
        },
      );
    } else {
      await for (final settings in _settings.stream) {
        yield right(
          settings.tags.firstWhere(
            (tag) => tag.id == tagID,
            orElse: () => TTag.empty(id: tagID),
          ),
        );
      }
    }
  }

  /// Adds the given audio files to the playlist for the provided tag.
  ///
  /// This fetches the latest settings, prompts the user to pick audio files,
  /// copies those files to storage, adds the file paths to the tag's playlist
  /// and saves the updated settings.
  ///
  /// Returns a [TTagPlaylistAdditionException] on failure and the updated
  /// [TTag] on success.
  Future<Either<TTagPlaylistAdditionException, TTag>> addFilesToTagPlaylist({
    required TTag tag,
  }) async {
    final settings = await _fetchSettings();

    return settings.fold(
      (exception) => left(
        switch (exception) {
          TSettingsLoadException.unknown =>
            TTagPlaylistAdditionException.settingsLoadFailure,
        },
      ),
      (settings) async {
        final sourceFiles = await filePickerClient.pickAudioFiles();

        return sourceFiles.fold(
          (exception) => left(
            switch (exception) {
              TFilePickException.unknown =>
                TTagPlaylistAdditionException.filePickFailure,
            },
          ),
          (sourceFiles) async {
            final files = await storageClient.copyAudioFiles(
              sourceFiles: sourceFiles,
            );

            return files.fold(
              (exception) => left(
                switch (exception) {
                  TFileCopyException.unknown =>
                    TTagPlaylistAdditionException.fileCopyFailure,
                },
              ),
              (files) async {
                final updatedTag = tag.copyWith(
                  playlist: Set.from(tag.playlist)
                    ..addAll(files.map((file) => file.path)),
                );

                final updatedSettings = settings.copyWith(
                  tags: Set.from(settings.tags)
                    ..removeWhere((tag) => tag.id == updatedTag.id)
                    ..add(updatedTag),
                );

                final saveResult = await _saveSettings(updatedSettings);

                return saveResult.fold(
                  (exception) => left(
                    switch (exception) {
                      TSettingsSaveException.unknown =>
                        TTagPlaylistAdditionException.settingsSaveFailure,
                    },
                  ),
                  (_) => right(updatedTag),
                );
              },
            );
          },
        );
      },
    );
  }

  /// Deletes a file from the playlist of the given tag.
  ///
  /// Fetches the settings, removes the file path from the tag's playlist,
  /// deletes the file if necessary and saves the updated settings.
  ///
  /// Returns a [TTagPlaylistDeletionException] on failure and the updated
  /// [TTag] on success.
  Future<Either<TTagPlaylistDeletionException, TTag>>
      deleteFileFromTagPlaylist({
    required TTag tag,
    required String filePath,
  }) async {
    final settings = await _fetchSettings();

    return settings.fold(
      (exception) => left(
        switch (exception) {
          TSettingsLoadException.unknown =>
            TTagPlaylistDeletionException.settingsLoadFailure,
        },
      ),
      (settings) async {
        var multipleTagsWithFileInPlaylist = false;

        for (final t in settings.tags) {
          if (t.id != tag.id && t.playlist.contains(filePath)) {
            multipleTagsWithFileInPlaylist = true;
            break;
          }
        }

        if (!multipleTagsWithFileInPlaylist) {
          final deleteResult = await storageClient.deleteFile(
            filePath: filePath,
          );
          if (deleteResult.isLeft()) {
            return left(
              switch (deleteResult.tAsLeft()) {
                TFileDeletionException.unknown =>
                  TTagPlaylistDeletionException.fileDeletionFailure,
              },
            );
          }
        }

        final updatedTag = tag.copyWith(
          playlist: Set.from(tag.playlist)
            ..removeWhere((file) => file == filePath),
        );

        final updatedSettings = settings.copyWith(
          tags: Set.from(settings.tags)
            ..removeWhere((tag) => tag.id == updatedTag.id)
            ..add(updatedTag),
        );

        final saveResult = await _saveSettings(updatedSettings);

        return saveResult.fold(
          (exception) => left(
            switch (exception) {
              TSettingsSaveException.unknown =>
                TTagPlaylistDeletionException.settingsSaveFailure,
            },
          ),
          (_) => right(updatedTag),
        );
      },
    );
  }
}
