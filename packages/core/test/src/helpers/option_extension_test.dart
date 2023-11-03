import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcore/core.dart';

void main() {
  group('TOptionExtension Tests', () {
    test('''
      Given: Some with some value,
      When: asSome,
      Then: returns value''', () {
      expect(some(12).tAsSome(), 12);
    });
  });
}
