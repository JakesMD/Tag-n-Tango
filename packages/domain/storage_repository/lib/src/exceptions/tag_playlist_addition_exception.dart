/// Represents an exception that occurs when adding files to a tag's playlist.
enum TTagPlaylistAdditionException {
  /// The exception occured while loading the settings.
  settingsLoadFailure,

  /// The exception occured while saving the settings.
  settingsSaveFailure,

  /// The exception occured while picking the files.
  filePickFailure,

  /// The exception occured while copying the files.
  fileCopyFailure,
}
