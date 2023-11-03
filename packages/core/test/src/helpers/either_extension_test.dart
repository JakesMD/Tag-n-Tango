import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcore/core.dart';

void main() {
  group('TEitherExtension Tests', () {
    test('''
      Given: Right with some value,
      When: asRight,
      Then: returns value''', () {
      expect(right(12).tAsRight(), 12);
    });
    test('''
      Given: Left with some value,
      When: asLeft,
      Then: returns value''', () {
      expect(left(32).tAsLeft(), 32);
    });
  });
}
