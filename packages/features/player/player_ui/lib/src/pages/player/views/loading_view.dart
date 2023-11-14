import 'package:flutter/material.dart';

/// {@template TPlayerLoadingView}
///
/// Displays a loading view.
///
/// {@endtemplate}
class TPlayerLoadingView extends StatelessWidget {
  /// {@macro TPlayerNoTagView}
  const TPlayerLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading...')),
      body: const LinearProgressIndicator(),
    );
  }
}
