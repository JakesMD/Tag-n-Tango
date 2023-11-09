import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tcore/core.dart';
import 'package:tfile_picker_client/file_picker_client.dart';
import 'package:tnfc_client/nfc_client.dart';
import 'package:tnfc_repository/nfc_repository.dart';
import 'package:tplayer_ui/player_ui.dart';
import 'package:tstorage_client/storage_client.dart';
import 'package:tstorage_repository/storage_repository.dart';

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
        RepositoryProvider(
          create: (context) => TStorageRepository(
            storageClient: TStorageClient(),
            filePickerClient: TFilePickerClient(),
          ),
        ),
      ],
      routerConfig: GoRouter(
        initialLocation: '/player',
        routes: $appRoutes,
      ),
      localizationsDelegates: const [],
    );
  }
}

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<TPlayerRoute>(path: 'player'),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

class TPlayerRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TPlayerPage();
  }
}
