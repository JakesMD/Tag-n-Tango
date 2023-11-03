import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tcore/core.dart';

export 'generated/localizations.g.dart';

/// {@template TCoreL10nExtension}
///
/// Provides access to this widget tree's [TCoreL10n] instance.
///
/// {@endtemplate}
extension TCoreL10nExtension on BuildContext {
  /// {@macro BCoreL10nExtension}
  TCoreL10n get tCoreL10n => TCoreL10n.of(this);
}

/// {@template TL10nDateExtension}
///
/// Formats the [DateTime] into a localized string with date and time
/// information for the current [BuildContext]'s locale.
///
/// {@endtemplate}
extension TL10nDateExtension on DateTime {
  /// {@macro TL10nDateExtension}
  String tLocalize(BuildContext context) => DateFormat.yMd(
        Localizations.localeOf(context).languageCode,
      ).format(this);
}

/// {@template TL10nNumExtension}
///
/// Formats the [num] into a localized string using the decimal pattern
/// for the current [BuildContext]'s locale.
///
/// {@endtemplate}
extension TL10nNumExtension on num {
  /// {@macro TL10nNumExtension}
  String tLocalize(BuildContext context, {int? decimalDigits}) {
    return NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).languageCode,
      decimalDigits: decimalDigits,
    ).format(this);
  }
}

/// {@template TL10nStringExtension}
/// Returns the number represented by this string localized to the given
/// [BuildContext]'s locale, or null if the string does not contain a valid
/// number.
///
/// {@endtemplate}
extension TL10nStringExtension on String {
  /// {@macro TL10nStringExtension}
  num? bToLocalizedNum(BuildContext context) {
    try {
      return NumberFormat.decimalPattern(
        Localizations.localeOf(context).languageCode,
      ).parse(this);
    } on FormatException catch (_) {
      return null;
    }
  }
}
