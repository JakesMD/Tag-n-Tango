import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:tnfc_client/nfc_client.dart';

/// Physical NFC client implementation using Flutter NFC Kit plugin.
class TPhysicalNFCClient implements TNFCClient {
  @override
  Stream<Either<TTagIDStreamException, String>> tagIDStream() async* {
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
          final tag = await FlutterNfcKit.poll(
            androidPlatformSound: false,
            androidCheckNDEF: false,
          );
          yield right(tag.id);
        } on PlatformException catch (exception) {
          // 408: session timeout
          if (exception.code != '408') rethrow;
        }
      }
    } catch (exception) {
      try {
        await FlutterNfcKit.finish();
      } catch (_) {}
      yield left(TTagIDStreamException.unknown);
    }
  }
}
