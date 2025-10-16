import 'dart:convert';

import 'package:bitkub_test/core/crypto/device_crypto_service.dart';
import 'package:flutter/services.dart';

class DeviceCryptoServiceImpl implements DeviceCryptoService {
  static const _ch = MethodChannel('com.example.bitkub_test.crypto.device');

  DeviceCryptoServiceImpl();

  @override
  Future<Uint8List> encrypt(Uint8List plain, {String? aad}) async {
    try {
      final res = await _ch.invokeMethod<Uint8List>('encrypt', {
        'data': plain,
        if (aad != null) 'aad': Uint8List.fromList(utf8.encode(aad)),
      });
      if (res == null) {
        throw DeviceCryptoException('NULL_RESULT', 'encrypt returned null');
      }
      if (res.length < 28) {
        throw DeviceCryptoException('BAD_LENGTH', 'combined < iv+tag');
      }
      return res;
    } on PlatformException catch (e) {
      throw DeviceCryptoException(e.code, e.message);
    }
  }

  @override
  Future<Uint8List> decrypt(Uint8List combined, {String? aad}) async {
    try {
      final res = await _ch.invokeMethod<Uint8List>('decrypt', {
        'data': combined,
        if (aad != null) 'aad': Uint8List.fromList(utf8.encode(aad)),
      });
      if (res == null) {
        throw DeviceCryptoException('NULL_RESULT', 'decrypt returned null');
      }
      return res;
    } on PlatformException catch (e) {
      throw DeviceCryptoException(e.code, e.message);
    }
  }
}
