import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcore/core.dart';

void main() {
  group('TGeneralErrorSnackBar Tests', () {
    testWidgets('When: built, Then: finds one snack bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: TCoreL10n.localizationsDelegates,
          home: Scaffold(
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () => BGeneralErrorSnackBar.show(context),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
