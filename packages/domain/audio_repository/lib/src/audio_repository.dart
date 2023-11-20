import 'package:dartz/dartz.dart';
import 'package:taudio_client/audio_client.dart';

export 'package:taudio_client/audio_client.dart'
    show
        TPlaylistAdditionException,
        TPlaylistDeletionException,
        TPlaylistPlayException,
        TPlaylistReorderException;

/// {@template TAudioRepository}
///
/// The audio repository provides an interface for playing playlists and
/// modifying the current playlist.
///
/// {@endtemplate}
class TAudioRepository {
  /// {@macro TAudioRepository}
  TAudioRepository({required this.audioClient});

  /// The audio client instance this repository will use for playing audio.
  final TAudioClient audioClient;

  /// Plays the provided playlist of audio files using the audio player.
  ///
  /// Returns either a unit value on success, or a [TPlaylistPlayException] on
  /// failure.
  Future<Either<TPlaylistPlayException, Unit>> playPlaylist({
    required List<String> playlist,
  }) {
    return audioClient.playPlaylist(playlist: playlist);
  }

  /// Deletes an audio file from the playlist at the given index.
  ///
  /// Returns either a unit value on success, or a [TPlaylistDeletionException]
  /// on failure.
  Future<Either<TPlaylistDeletionException, Unit>> deleteFromPlaylist({
    required int removeAt,
  }) {
    return audioClient.deleteFromPlaylist(removeAt: removeAt);
  }

  /// Adds an audio file to the playlist at the given index.
  ///
  /// Returns either a unit value on success, or a [TPlaylistAdditionException]
  /// on failure.
  Future<Either<TPlaylistAdditionException, Unit>> addToPlaylist({
    required String filePath,
    required int index,
  }) {
    return audioClient.addToPlaylist(filePath: filePath, index: index);
  }

  /// Reorders the items in the playlist by moving the item at [oldIndex]
  /// to [newIndex].
  ///
  /// Returns either [unit] on success, or a [TPlaylistReorderException] on
  /// failure.
  Future<Either<TPlaylistReorderException, Unit>> reorderPlaylist({
    required int oldIndex,
    required int newIndex,
  }) {
    return audioClient.reorderPlaylist(oldIndex: oldIndex, newIndex: newIndex);
  }
}
