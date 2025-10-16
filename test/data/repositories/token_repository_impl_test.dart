import 'dart:convert';
import 'dart:typed_data';

import 'package:bitkub_test/core/env.dart';
import 'package:bitkub_test/data/repositories/token_repository_impl.dart';
import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  const storageKey = 'key_auth';
  const aad = 'auth:v1';

  test('Env sanity check', () {
    expect(Env.keyAuth, storageKey);
    expect(Env.aadAuth, aad);
  });

  late MockFlutterSecureStorage storage;
  late MockDeviceCryptoService crypto;

  setUp(() {
    storage = MockFlutterSecureStorage();
    crypto = MockDeviceCryptoService();
  });

  group('TokenRepositoryImpl', () {
    test('saveAuth writes Base64 blob and calls encrypt', () async {
      final repo = TokenRepositoryImpl(storage, crypto);

      when(
        crypto.encrypt(any, aad: anyNamed('aad')),
      ).thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));

      final auth = const Auth();

      await repo.saveAuth(auth);

      verify(crypto.encrypt(any, aad: aad)).called(1);

      final expectedJson = jsonEncode({
        'blob': base64Encode(const [1, 2, 3]),
      });

      verify(
        storage.write(key: storageKey, value: expectedJson),
      ).called(1);
    });

    test('readAuth returns null if storage empty', () async {
      final repo = TokenRepositoryImpl(storage, crypto);
      when(storage.read(key: storageKey)).thenAnswer((_) async => null);

      final result = await repo.readAuth();

      expect(result, isNull);
      verifyNever(crypto.decrypt(any, aad: anyNamed('aad')));
    });

    test('readAuth decrypts blob and returns Auth', () async {
      final repo = TokenRepositoryImpl(storage, crypto);

      final combined = Uint8List.fromList([7, 8, 9]);
      final payload = jsonEncode({'blob': base64Encode(combined)});
      when(storage.read(key: storageKey)).thenAnswer((_) async => payload);

      const decryptedJson = '{"accessToken":"T","refreshToken":"R"}';
      when(
        crypto.decrypt(combined, aad: aad),
      ).thenAnswer((_) async => Uint8List.fromList(utf8.encode(decryptedJson)));

      final result = await repo.readAuth();

      expect(result, isA<Auth>());
      verify(crypto.decrypt(combined, aad: aad)).called(1);
    });

    test('invalid blob returns null safely', () async {
      final repo = TokenRepositoryImpl(storage, crypto);

      when(
        storage.read(key: storageKey),
      ).thenAnswer((_) async => jsonEncode({'blob': 'BAD@@@@'}));

      final result = await repo.readAuth();

      expect(result, isNull);
    });

    test('clear wipes storage and cache', () async {
      final repo = TokenRepositoryImpl(storage, crypto);
      when(storage.delete(key: storageKey)).thenAnswer((_) async {});

      await repo.clear();

      verify(storage.delete(key: storageKey)).called(1);
    });

    test('cache: second read does not touch storage', () async {
      final repo = TokenRepositoryImpl(storage, crypto);

      when(
        crypto.encrypt(any, aad: anyNamed('aad')),
      ).thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));

      await repo.saveAuth(const Auth());

      final result = await repo.readAuth();

      expect(result, isA<Auth>());
      verifyNever(storage.read(key: anyNamed('key')));
    });
  });
}
