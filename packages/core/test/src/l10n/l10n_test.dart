import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcore/core.dart';

void main() {
  group('TCoreL10nExtension Tests', () {
    testWidgets('When: fetch localizations, Then: returns BCoreL10n',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: TCoreL10n.localizationsDelegates,
          home: Builder(
            builder: (context) {
              expect(context.tCoreL10n, isA<TCoreL10n>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('TL10nDateExtension Tests', () {
    testWidgets('When: fetch localized date, Then: returns string',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: TCoreL10n.localizationsDelegates,
          home: Builder(
            builder: (context) {
              expect(DateTime.now().tLocalize(context), isA<String>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('TL10nNumExtension Tests', () {
    testWidgets('When: fetch localized number, Then: returns string',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: TCoreL10n.localizationsDelegates,
          home: Builder(
            builder: (context) {
              expect(22.3.tLocalize(context), isA<String>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('TL10nStringExtension Tests', () {
    testWidgets('When: fetch number from invalid string, Then: returns null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: TCoreL10n.localizationsDelegates,
          home: Builder(
            builder: (context) {
              expect('blablabla'.bToLocalizedNum(context), isNull);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
