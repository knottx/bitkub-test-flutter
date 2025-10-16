import 'package:bitkub_test/data/dtos/sign_up_token_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpTokenDto', () {
    test('fromJson should parse correctly', () {
      const json = {'token': 'signup_abc123'};
      final dto = SignUpTokenDto.fromJson(json);

      expect(dto.token, 'signup_abc123');
    });

    test('fromJson should handle null token', () {
      const json = {'token': null};
      final dto = SignUpTokenDto.fromJson(json);

      expect(dto.token, isNull);
    });

    test('fromJson should handle missing key safely', () {
      final dto = SignUpTokenDto.fromJson({});
      expect(dto.token, isNull);
    });
  });
}
