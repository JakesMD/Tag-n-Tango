import 'package:flutter_test/flutter_test.dart';
import 'package:tstorage_client/storage_client.dart';

void main() {
  group('TTag Tests', () {
    test('''
      Given: tag,
      When: to JSON and then from JSON,
      Then: returns the same tag
      ''', () {
      const matcher = TTag(id: '123', playlist: ['some file']);

      final actual = TTag.fromJSON(json: matcher.toJSON());

      expect(actual, matcher);
    });
  });
}
