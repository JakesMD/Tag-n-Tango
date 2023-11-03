import 'localizations.g.dart';

/// The translations for English (`en`).
class TCoreL10nEn extends TCoreL10n {
  TCoreL10nEn([String locale = 'en']) : super(locale);

  @override
  String get measuringUnit_pieces_abbr => 'pcs';

  @override
  String get measuringUnit_grams_abbr => 'g';

  @override
  String get measuringUnit_milliliters_abbr => 'ml';

  @override
  String get inputError_positiveNumber => 'Please enter a positive number.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get snackBar_error_general =>
      'Oops! Something went wrong. Please check your internet connection and try again.';
}
