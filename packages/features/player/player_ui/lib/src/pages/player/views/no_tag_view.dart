import 'package:flutter/material.dart';

/// {@template TPlayerNoTagView}
///
/// Displayed when no tag has been beeped yet.
///
/// {@endtemplate}
class TPlayerNoTagView extends StatelessWidget {
  /// {@macro TPlayerNoTagView}
  const TPlayerNoTagView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('No Tag')),
    );
  }
}
