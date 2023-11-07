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
      const matcher = TSettings(tags: [TTag.empty(id: '123')]);

      final actual = TSettings.fromJSON(json: matcher.toJSON());

      expect(actual, matcher);
    });
  });
}
