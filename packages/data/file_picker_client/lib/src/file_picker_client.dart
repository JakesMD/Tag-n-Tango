import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tfile_picker_client/file_picker_client.dart';

export 'dart:io' show File;

/// Client for picking files from the user's device.
class TFilePickerClient {
  /// Picks multiple audio files from the device storage.
  ///
  /// Uses the FilePicker plugin to open a file picker dialog filtered to audio
  /// files. Returns either a [TFilePickException] on failure, or a list of
  /// [File] objects representing the selected audio files on success.
  Future<Either<TFilePickException, List<File>>> pickAudioFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result == null) return right([]);

      return right(result.paths.map((path) => File(path!)).toList());
    } catch (exception) {
      return left(TFilePickException.unknown);
    }
  }
}
