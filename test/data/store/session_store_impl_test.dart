import 'dart:convert';

import 'package:bitkub_test/data/mappers/auth_mapper.dart';
import 'package:bitkub_test/data/store/session_store_impl.dart';
import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  const keyAuth = 'auth';
  const auth = Auth(accessToken: 'access_123');
  const encodedJson = '{"accessToken":"access_123"}';

  late MockFlutterSecureStorage storage;
  late SessionStoreImpl sessionStore;

  setUp(() {
    storage = MockFlutterSecureStorage();
    sessionStore = SessionStoreImpl(storage);
  });

  group('SessionStoreImpl', () {
    test('saveAuth writes encoded AuthDto to secure storage', () async {
      when(
        storage.write(key: anyNamed('key'), value: anyNamed('value')),
      ).thenAnswer((_) async {});

      await sessionStore.saveAuth(auth);

      verify(
        storage.write(
          key: keyAuth,
          value: jsonEncode(AuthMapper.toDto(auth).toJson()),
        ),
      ).called(1);
    });

    test('readAuth returns cached value if already loaded', () async {
      when(
        storage.read(key: anyNamed('key')),
      ).thenAnswer((_) async => encodedJson);

      await sessionStore.readAuth();

      await sessionStore.readAuth();

      verify(storage.read(key: keyAuth)).called(1);
    });

    test(
      'readAuth reads from storage and maps correctly when cache empty',
      () async {
        when(storage.read(key: keyAuth)).thenAnswer((_) async => encodedJson);

        final result = await sessionStore.readAuth();

        expect(result, isA<Auth>());
        expect(result?.accessToken, auth.accessToken);
        verify(storage.read(key: keyAuth)).called(1);
      },
    );

    test('readAuth returns null when no data in storage', () async {
      when(storage.read(key: keyAuth)).thenAnswer((_) async => null);

      final result = await sessionStore.readAuth();

      expect(result, isNull);
      verify(storage.read(key: keyAuth)).called(1);
    });

    test('clear deletes key and resets cache', () async {
      when(
        storage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async {});
      when(
        storage.delete(key: anyNamed('key')),
      ).thenAnswer((_) async {});
      when(
        storage.read(key: keyAuth),
      ).thenAnswer((_) async => null);

      await sessionStore.saveAuth(auth);

      await sessionStore.clear();
      final result = await sessionStore.readAuth();

      verify(storage.delete(key: keyAuth)).called(1);
      expect(result, isNull);
    });
  });
}
