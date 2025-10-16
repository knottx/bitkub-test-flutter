import 'package:bitkub_test/data/dtos/auth_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthDto', () {
    test('fromJson should parse correctly', () {
      const json = {'accessToken': 'abc123'};
      final dto = AuthDto.fromJson(json);

      expect(dto.accessToken, 'abc123');
    });

    test('toJson should convert correctly', () {
      const dto = AuthDto(accessToken: 'xyz789');
      final json = dto.toJson();

      expect(json, {'accessToken': 'xyz789'});
    });

    test('fromJson should handle missing key safely', () {
      final dto = AuthDto.fromJson({});
      expect(dto.accessToken, isNull);
    });
  });
}
