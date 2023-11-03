import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tcore/core.dart';

void main() {
  group('TApp Tests', () {
    testWidgets('When: built, Then: finds one TApp', (tester) async {
      await tester.pumpWidget(
        TApp(
          providers: [RepositoryProvider(create: (_) => Object())],
          localizationsDelegates: const [],
          routerConfig: GoRouter(routes: []),
        ),
      );

      expect(find.byType(TApp), findsOneWidget);
    });
  });
}
