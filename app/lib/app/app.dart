// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tcore/core.dart';

part 'app.g.dart';

class TagNTangoApp extends StatelessWidget {
  const TagNTangoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TApp(
      providers: [RepositoryProvider(create: (context) => Object())],
      routerConfig: GoRouter(
        initialLocation: '/cards',
        routes: $appRoutes,
      ),
      localizationsDelegates: const [],
    );
  }
}

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<TCardsPageRoute>(
      path: 'cards',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

class TCardsPageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cards')),
    );
  }
}
