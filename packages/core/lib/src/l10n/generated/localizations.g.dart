import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_de.g.dart';
import 'localizations_en.g.dart';

/// Callers can lookup localized strings with an instance of TCoreL10n
/// returned by `TCoreL10n.of(context)`.
///
/// Applications need to include `TCoreL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/localizations.g.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TCoreL10n.localizationsDelegates,
///   supportedLocales: TCoreL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TCoreL10n.supportedLocales
/// property.
abstract class TCoreL10n {
  TCoreL10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TCoreL10n of(BuildContext context) {
    return Localizations.of<TCoreL10n>(context, TCoreL10n)!;
  }

  static const LocalizationsDelegate<TCoreL10n> delegate = _TCoreL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @measuringUnit_pieces_abbr.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get measuringUnit_pieces_abbr;

  /// No description provided for @measuringUnit_grams_abbr.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get measuringUnit_grams_abbr;

  /// No description provided for @measuringUnit_milliliters_abbr.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get measuringUnit_milliliters_abbr;

  /// No description provided for @inputError_positiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a positive number.'**
  String get inputError_positiveNumber;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @snackBar_error_general.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong. Please check your internet connection and try again.'**
  String get snackBar_error_general;
}

class _TCoreL10nDelegate extends LocalizationsDelegate<TCoreL10n> {
  const _TCoreL10nDelegate();

  @override
  Future<TCoreL10n> load(Locale locale) {
    return SynchronousFuture<TCoreL10n>(lookupTCoreL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_TCoreL10nDelegate old) => false;
}

TCoreL10n lookupTCoreL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return TCoreL10nDe();
    case 'en':
      return TCoreL10nEn();
  }

  throw FlutterError(
      'TCoreL10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
