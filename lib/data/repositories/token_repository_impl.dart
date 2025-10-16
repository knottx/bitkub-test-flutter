import 'dart:convert';
import 'dart:typed_data';

import 'package:bitkub_test/core/crypto/device_crypto_service.dart';
import 'package:bitkub_test/core/env.dart';
import 'package:bitkub_test/data/dtos/auth_dto.dart';
import 'package:bitkub_test/data/mappers/auth_mapper.dart';
import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/repositories/token_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepositoryImpl implements TokenRepository {
  final FlutterSecureStorage _storage;
  final DeviceCryptoService _crypto;

  Auth? _auth;

  TokenRepositoryImpl(
    this._storage,
    this._crypto,
  );

  @override
  Future<void> saveAuth(Auth auth) async {
    _auth = auth;
    final authDto = AuthMapper.toDto(auth);
    final rawJson = jsonEncode(authDto.toJson());
    final encrypted = await _encrypt(rawJson, aad: Env.aadAuth);

    return _storage.write(
      key: Env.keyAuth,
      value: jsonEncode(encrypted),
    );
  }

  @override
  Future<Auth?> readAuth() async {
    if (_auth != null) return _auth;

    final jsonData = await _storage.read(key: Env.keyAuth);
    if (jsonData == null) return null;

    try {
      final payload = jsonDecode(jsonData) as Map<String, dynamic>;
      final decrypted = await _decrypt(payload, aad: Env.aadAuth);

      final dto = AuthDto.fromJson(jsonDecode(decrypted));
      _auth = AuthMapper.toEntity(dto);
      return _auth;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> clear() {
    _auth = null;
    return _storage.delete(key: Env.keyAuth);
  }

  Future<Map<String, dynamic>> _encrypt(
    String plaintext, {
    required String aad,
  }) async {
    final combined = await _crypto.encrypt(
      Uint8List.fromList(utf8.encode(plaintext)),
      aad: aad,
    );
    return {
      'blob': base64Encode(combined),
    };
  }

  Future<String> _decrypt(
    Map<String, dynamic> payload, {
    required String aad,
  }) async {
    final blobB64 = payload['blob'] as String?;
    if (blobB64 == null) {
      throw StateError('Missing blob');
    }

    final combined = base64Decode(blobB64);
    final plainBytes = await _crypto.decrypt(combined, aad: aad);
    return utf8.decode(plainBytes);
  }
}
