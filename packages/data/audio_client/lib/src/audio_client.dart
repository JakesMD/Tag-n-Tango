// coverage:ignore-file

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:taudio_client/audio_client.dart';

/// Client for playing audio playlists.
class TAudioClient {
  final _player = AudioPlayer();

  ConcatenatingAudioSource? _playlist;

  /// Plays the provided playlist of audio files using the audio player.
  ///
  /// Returns either a unit value on success, or a [TPlaylistPlayException] on
  /// failure.
  Future<Either<TPlaylistPlayException, Unit>> playPlaylist({
    required List<String> playlist,
  }) async {
    try {
      _playlist = ConcatenatingAudioSource(
        children: [
          ...playlist.map((file) => AudioSource.uri(Uri.file(file))),
        ],
      );

      await _player.setAudioSource(
        _playlist!,
        initialIndex: 0,
        initialPosition: Duration.zero,
      );
      await _player.setLoopMode(LoopMode.all);

      unawaited(_player.play());

      return right(unit);
    } catch (exception) {
      return left(TPlaylistPlayException.unknown);
    }
  }

  /// Deletes an audio file from the playlist at the given index.
  ///
  /// Returns either a unit value on success, or a [TPlaylistDeletionException]
  /// on failure.
  Future<Either<TPlaylistDeletionException, Unit>> deleteFromPlaylist({
    required int removeAt,
  }) async {
    try {
      await _playlist?.removeAt(removeAt);

      return right(unit);
    } catch (exception) {
      return left(TPlaylistDeletionException.unknown);
    }
  }

  /// Adds an audio file to the playlist at the given index.
  ///
  /// Returns either a unit value on success, or a [TPlaylistAdditionException]
  /// on failure.
  Future<Either<TPlaylistAdditionException, Unit>> addToPlaylist({
    required String filePath,
    required int index,
  }) async {
    try {
      await _playlist?.insert(index, AudioSource.uri(Uri.file(filePath)));

      return right(unit);
    } catch (exception) {
      return left(TPlaylistAdditionException.unknown);
    }
  }

  /// Reorders the items in the playlist by moving the item at [oldIndex]
  /// to [newIndex].
  ///
  /// Returns either [unit] on success, or a [TPlaylistReorderException] on
  /// failure.
  Future<Either<TPlaylistReorderException, Unit>> reorderPlaylist({
    required int oldIndex,
    required int newIndex,
  }) async {
    try {
      await _playlist?.move(oldIndex, newIndex);

      return right(unit);
    } catch (exception) {
      return left(TPlaylistReorderException.unknown);
    }
  }
}
