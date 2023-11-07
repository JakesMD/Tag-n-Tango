import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tcore/core.dart';
import 'package:tnfc_client/nfc_client.dart';
import 'package:tnfc_repository/nfc_repository.dart';
import 'package:tplayer_ui/player_ui.dart';

part 'app.g.dart';

class TagNTangoApp extends StatelessWidget {
  const TagNTangoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TApp(
      providers: [
        RepositoryProvider(
          create: (context) => TNFCRepository(nfcClient: TPhysicalNFCClient()),
        ),
      ],
      routerConfig: GoRouter(
        initialLocation: '/test',
        routes: $appRoutes,
      ),
      localizationsDelegates: const [],
    );
  }
}

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<TTestRoute>(path: 'test'),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

class TTestRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TTestPage();
  }
}
