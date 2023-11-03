// ignore_for_file: one_member_abstracts

import 'package:dartz/dartz.dart';
import 'package:tnfc_client/nfc_client.dart';

/// The client interface for reading from NFC tags.
abstract interface class TNFCClient {
  /// Returns a stream of tag ID strings read from the NFC device.
  ///
  /// The stream emits either a [TTagIDStreamException] on error, or a tag ID
  /// string on success.
  Stream<Either<TTagIDStreamException, Option<String>>> tagIDsStream();
}
