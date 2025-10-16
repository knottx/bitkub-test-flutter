import 'dart:async';
import 'dart:convert';

import 'package:bitkub_test/data/dtos/auth_dto.dart';
import 'package:bitkub_test/data/mappers/auth_mapper.dart';
import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/store/session_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStoreImpl implements SessionStore {
  static const _keyAuth = 'auth';

  final FlutterSecureStorage _storage;

  Auth? _auth;

  SessionStoreImpl(this._storage);

  @override
  Future<void> saveAuth(Auth auth) {
    _auth = auth;
    final authDto = AuthMapper.toDto(auth);
    return _storage.write(
      key: _keyAuth,
      value: jsonEncode(authDto.toJson()),
    );
  }

  @override
  Future<Auth?> readAuth() async {
    if (_auth != null) return _auth;

    final authJsonData = await _storage.read(key: _keyAuth);
    if (authJsonData == null) return null;

    final authDto = AuthDto.fromJson(jsonDecode(authJsonData));
    _auth = AuthMapper.toEntity(authDto);
    return _auth;
  }

  @override
  Future<void> clear() {
    _auth = null;
    return _storage.delete(key: _keyAuth);
  }
}
