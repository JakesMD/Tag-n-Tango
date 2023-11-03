import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:tnfc_client/nfc_client.dart';

/// The physical NFC client that reads from NFC tags.
class TPhysicalNFCClient implements TNFCClient {
  @override
  Stream<Either<TTagIDStreamException, Option<String>>> tagIDsStream() async* {
    String? lastTagID;

    try {
      final availability = await FlutterNfcKit.nfcAvailability;

      switch (availability) {
        case NFCAvailability.disabled:
          yield left(TTagIDStreamException.nfcDisabled);
        case NFCAvailability.not_supported:
          yield left(TTagIDStreamException.nfcNotSupported);
        case NFCAvailability.available:
          break;
      }

      while (true) {
        try {
          final tag = await FlutterNfcKit.poll();
          await FlutterNfcKit.finish();

          if (tag.id != lastTagID) {
            lastTagID = tag.id;
            yield right(some(tag.id));
          }
        } on PlatformException catch (exception) {
          if (exception.code == '408') {
            if (lastTagID != null) {
              lastTagID = null;
              yield right(none());
            }
          } else {
            rethrow;
          }
        }
      }
    } catch (exception) {
      yield left(TTagIDStreamException.unknown);
    }
  }
}
