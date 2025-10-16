import 'dart:typed_data';

abstract class DeviceCryptoService {
  Future<Uint8List> encrypt(Uint8List plain, {String? aad});
  Future<Uint8List> decrypt(Uint8List combined, {String? aad});
}

class DeviceCryptoException implements Exception {
  final String code;
  final String? message;

  DeviceCryptoException(
    this.code,
    this.message,
  );

  @override
  String toString() => 'DeviceCryptoException($code, $message)';
}
