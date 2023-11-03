import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:tnfc_client/nfc_client.dart';

/// The physical NFC client that reads from NFC tags.
class TPhysicalNFCClient implements TNFCClient {
  @override
  Stream<Either<TTagIDStreamException, String>> tagIDsStream() async* {
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
          yield right(tag.id);
        } on PlatformException catch (exception) {
          if (exception.code == '408') {}
        }
      }
    } catch (exception) {
      yield left(TTagIDStreamException.unknown);
    }
  }
}
