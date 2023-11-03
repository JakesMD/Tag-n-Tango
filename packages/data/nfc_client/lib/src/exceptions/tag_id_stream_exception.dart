/// Represents an exception that occurs when streaming NFC tag IDs.
enum TTagIDStreamException {
  /// The error was unitentifiable.
  unknown,

  /// NFC is disabled on the device.
  nfcDisabled,

  /// NFC is not supported on the device.
  nfcNotSupported,
}
