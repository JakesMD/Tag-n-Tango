import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tcore/core.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('TFormInput Tests', () {
    late TFormInput<dynamic> input;

    setUp(() {
      input = TFormInput();
    });

    test('''
      When: first initialized,
      Then: input is null''', () {
      expect(input.input, isNull);
    });

    test('''
      Given: new input,
      When: onChanged,
      Then: input is new input''', () {
      input.onChanged('new input');
      expect(input.input, 'new input');
    });
  });
}
