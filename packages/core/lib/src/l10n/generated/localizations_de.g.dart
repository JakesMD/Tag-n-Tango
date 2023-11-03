import 'localizations.g.dart';

/// The translations for German (`de`).
class TCoreL10nDe extends TCoreL10n {
  TCoreL10nDe([String locale = 'de']) : super(locale);

  @override
  String get measuringUnit_pieces_abbr => 'Stk';

  @override
  String get measuringUnit_grams_abbr => 'g';

  @override
  String get measuringUnit_milliliters_abbr => 'ml';

  @override
  String get inputError_positiveNumber =>
      'Bitte geben Sie eine positive Zahl ein.';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get snackBar_error_general =>
      'Hoppla! Etwas ist schiefgelaufen. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';
}
