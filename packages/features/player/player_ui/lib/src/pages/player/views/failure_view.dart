import 'package:flutter/material.dart';

/// {@template TPlayerFailureView}
///
/// Displays an error view.
///
/// {@endtemplate}
class TPlayerFailureView extends StatelessWidget {
  /// {@macro TPlayerFailureView}
  const TPlayerFailureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
    );
  }
}
