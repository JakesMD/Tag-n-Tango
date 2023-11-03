import 'package:dartz/dartz.dart';
import 'package:tnfc_client/nfc_client.dart';

export 'package:tnfc_client/nfc_client.dart' show TTagIDStreamException;

/// Repository for interacting with an NFC device to read tag IDs.
class TNFCRepository {
  /// {@macro TNFCRepository}
  const TNFCRepository({required this.nfcClient});

  /// The NFC client instance this repository will use for reading tags.
  final TNFCClient nfcClient;

  /// Returns a stream of tag ID strings read from the NFC device.
  ///
  /// The stream emits either a [TTagIDStreamException] on error, or a tag ID
  /// string on success.
  Stream<Either<TTagIDStreamException, Option<String>>> tagIDsStream() =>
      nfcClient.tagIDsStream();
}
