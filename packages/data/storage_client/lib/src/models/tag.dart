import 'package:equatable/equatable.dart';

/// {@template TTag}
///
/// Represents a physical NFC tag containing audio file references.
///
/// This class models the data the physical NFC tag represents.
/// It contains a unique ID and playlist of audio files associated
/// with the tag.
///
/// {@endtemplate}
class TTag with EquatableMixin {
  /// {@macro TTag}
  const TTag({required this.id, required this.playlist});

  /// {@macro TTag}
  ///
  /// The fields are prefilled (partly for testing purposes).
  const TTag.empty({required this.id}) : playlist = const [];

  /// {@macro TTag}
  ///
  /// Constructs a [TTag] from a JSON map.
  factory TTag.fromJSON({required Map<String, dynamic> json}) {
    return TTag(
      id: json['id'] as String,
      playlist: json['playlist'] as List<String>,
    );
  }

  /// The unique identifier stored on the physical tag.
  final String id;

  /// The list of audio file paths the tag represents.
  final List<String> playlist;

  /// Converts this [TTag] instance to a JSON-serializable Map.
  Map<String, dynamic> toJSON() => {
        'id': id,
        'playlist': playlist,
      };

  @override
  List<Object?> get props => [id, playlist];
}
