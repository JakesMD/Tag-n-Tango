import 'package:flutter_test/flutter_test.dart';
import 'package:tstorage_client/storage_client.dart';

void main() {
  group('TSettings Tests', () {
    test('''
      When: constructed empty,
      Then: returns settings
      ''', () {
      expect(const TSettings.empty(), isA<TSettings>());
    });

    test('''
      Given: settings,
      When: to JSON and then from JSON,
      Then: returns the same settings
      ''', () {
      final matcher = TSettings(tags: {const TTag.empty(id: '123')});

      final actual = TSettings.fromJSON(json: matcher.toJSON());

      expect(actual, matcher);
    });

    test('''
      Given: settings,
      When: copy with no parameters,
      Then: returns the same settings''', () {
      const matcher = TSettings.empty();
      final actual = const TSettings.empty().copyWith();

      expect(actual, matcher);
    });

    test('''
      Given: settings,
      When: copy with parameters,
      Then: returns the same settings with new parameters''', () {
      final matcher = TSettings(tags: {const TTag.empty(id: '123')});
      final actual = const TSettings(tags: {}).copyWith(
        tags: {const TTag.empty(id: '123')},
      );

      expect(actual, matcher);
    });
  });
}
