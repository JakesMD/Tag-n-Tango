import 'package:equatable/equatable.dart';
import 'package:tstorage_client/storage_client.dart';

/// {@template TSettings}
///
/// The settings model containing user-configured tags and playlists.
/// This is persisted locally.
///
/// {@endtemplate}
class TSettings with EquatableMixin {
  /// {@macro TSettings}
  const TSettings({required this.tags});

  /// {@macro TSettings}
  ///
  /// The fields are prefilled (partly for testing purposes).
  const TSettings.empty() : tags = const {};

  /// {@macro TSettings}
  ///
  /// Constructs a [TSettings] from a JSON map.
  TSettings.fromJSON({required Map<String, dynamic> json})
      : tags = Set<Map<String, dynamic>>.from(json['tags'] as List)
            .map((json) => TTag.fromJSON(json: json))
            .toSet();

  /// The list of NFC tags the user has associated playlists to.
  final Set<TTag> tags;

  /// Creates a copy of this [TSettings] instance with the given fields replaced
  /// with new values.
  TSettings copyWith({Set<TTag>? tags}) {
    return TSettings(tags: tags ?? this.tags);
  }

  /// Converts this [TSettings] instance to a JSON-serializable Map.
  Map<String, dynamic> toJSON() => {
        'tags': tags.map((tag) => tag.toJSON()).toList(),
      };

  @override
  List<Object?> get props => [tags];
}
