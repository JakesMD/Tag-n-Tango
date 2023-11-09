import 'package:flutter_test/flutter_test.dart';
import 'package:tstorage_client/storage_client.dart';

void main() {
  group('TTag Tests', () {
    test('''
      Given: tag,
      When: to JSON and then from JSON,
      Then: returns the same tag
      ''', () {
      const matcher = TTag(id: '123', playlist: {'some file'});

      final actual = TTag.fromJSON(json: matcher.toJSON());

      expect(actual, matcher);
    });

    test('''
      Given: tag,
      When: copy with no parameters,
      Then: returns the same tag''', () {
      const matcher = TTag.empty(id: '123');
      final actual = const TTag.empty(id: '123').copyWith();

      expect(actual, matcher);
    });

    test('''
      Given: tag,
      When: copy with parameters,
      Then: returns the same tag with new parameters''', () {
      const matcher = TTag(id: '123', playlist: {'someFilePath'});
      final actual = const TTag(id: '123', playlist: {}).copyWith(
        playlist: {'someFilePath'},
      );

      expect(actual, matcher);
    });
  });
}
