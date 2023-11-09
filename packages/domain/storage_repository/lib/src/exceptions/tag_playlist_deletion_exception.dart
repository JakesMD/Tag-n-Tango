/// Represents an exception that occurs when deleting a file from a tag's
/// playlist.
enum TTagPlaylistDeletionException {
  /// The exception occured while loading the settings.
  settingsLoadFailure,

  /// The exception occured while saving the settings.
  settingsSaveFailure,

  /// The exception occured while deleting the file.
  fileDeletionFailure,
}
