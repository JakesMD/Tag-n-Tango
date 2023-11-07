import 'package:equatable/equatable.dart';
import 'package:tstorage_client/storage_client.dart';

/// {@template TSettings}
///
/// The settings model containing user-configured tags and playlists.
/// This is persisted locally.
///
/// {@endtemplate TSettinge}
class TSettings with EquatableMixin {
  /// {@macro TSettings}
  const TSettings({required this.tags});

  /// {@macro TSettings}
  ///
  /// The fields are prefilled (partly for testing purposes).
  const TSettings.empty() : tags = const [];

  /// {@macro TSettings}
  ///
  /// Constructs a [TSettings] from a JSON map.
  factory TSettings.fromJSON({required Map<String, dynamic> json}) {
    return TSettings(
      tags: List<Map<String, dynamic>>.from(json['tags'] as List)
          .map((json) => TTag.fromJSON(json: json))
          .toList(),
    );
  }

  /// The list of NFC tags the user has associated playlists to.
  final List<TTag> tags;

  /// Converts this [TSettings] instance to a JSON-serializable Map.
  Map<String, dynamic> toJSON() => {
        'tags': tags.map((tag) => tag.toJSON()).toList(),
      };

  @override
  List<Object?> get props => [tags];
}
