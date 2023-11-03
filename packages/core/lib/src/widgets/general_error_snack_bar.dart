import 'package:flutter/material.dart';
import 'package:tcore/core.dart';

/// A general error [SnackBar].
class BGeneralErrorSnackBar {
  /// Shows the snack bar.
  static void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tCoreL10n.snackBar_error_general)),
    );
  }
}
