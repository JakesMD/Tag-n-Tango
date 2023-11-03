import 'package:dartz/dartz.dart';

/// Provides extension methods for the [Option] type from dartz.
extension TOptionExtension<T> on Option<T> {
  /// Returns the some value brute forcefully.
  ///
  /// Will fail if not checked with `isSome()` or `!isNone()` beforehand.
  T tAsSome() => (this as Some<T>).value;
}
