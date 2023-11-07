import 'package:dartz/dartz.dart';
import 'package:tnfc_client/nfc_client.dart';

/// The fake or virtual NFC client.
class TVirtualNFCClient implements TNFCClient {
  @override
  Stream<Either<TTagIDStreamException, String>> tagIDStream() async* {
    yield right('83756');
  }
}
