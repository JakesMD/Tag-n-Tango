import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nested/nested.dart';
import 'package:tcore/core.dart';

/// {@template TApp}
///
/// The root widget for the application.
///
/// Configures providers, localization, routing, and visual theme.
///
/// {@endtemplate}
class TApp extends StatelessWidget {
  /// {@macro TApp}
  const TApp({
    required this.providers,
    required this.localizationsDelegates,
    required this.routerConfig,
    super.key,
  });

  /// The list of providers to inject into the widget tree.
  ///
  /// This allows injecting repositories to make them available throughout the
  /// app.
  final List<SingleChildWidget> providers;

  /// The delegates for this app's [Localizations] widget.
  ///
  /// The delegates collectively define all of the localized resources for this
  /// application's [Localizations] widget.
  ///
  /// GlobalMaterialLocalizationsDelegate, GlobalCupertinoLocalizationsDelegate,
  /// GlobalWidgetsLocalizationsDelegate and [TCoreL10n.delegate] will be
  /// added additionally.
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  /// An object to configure the underlying [Router].
  ///
  /// Generally we use a GoRouter.
  final RouterConfig<Object> routerConfig;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: providers,
      child: DynamicColorBuilder(
        builder: (lightColorScheme, darkColorScheme) {
          return MaterialApp.router(
            title: "Tag 'n' Tango",
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.robotoTextTheme(),
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.robotoTextTheme(),
            ),
            themeMode: ThemeMode.light,
            localizationsDelegates: [
              ...TCoreL10n.localizationsDelegates,
              ...localizationsDelegates,
            ],
            supportedLocales: TCoreL10n.supportedLocales,
            routerConfig: routerConfig,
          );
        },
      ),
    );
  }
}
