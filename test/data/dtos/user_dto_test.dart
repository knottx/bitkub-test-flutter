import 'package:bitkub_test/data/dtos/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserDto', () {
    test('fromJson should parse correctly', () {
      const json = {
        'id': 'user_001',
        'firstName': 'Knot',
        'lastName': 'Tippun',
        'phoneNumber': '+66999999999',
      };

      final dto = UserDto.fromJson(json);

      expect(dto.id, 'user_001');
      expect(dto.firstName, 'Knot');
      expect(dto.lastName, 'Tippun');
      expect(dto.phoneNumber, '+66999999999');
    });

    test('fromJson should handle null values', () {
      const json = {
        'id': null,
        'firstName': null,
        'lastName': null,
        'phoneNumber': null,
      };

      final dto = UserDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.firstName, isNull);
      expect(dto.lastName, isNull);
      expect(dto.phoneNumber, isNull);
    });

    test('fromJson should handle missing keys safely', () {
      final dto = UserDto.fromJson({});
      expect(dto.id, isNull);
      expect(dto.firstName, isNull);
      expect(dto.lastName, isNull);
      expect(dto.phoneNumber, isNull);
    });
  });
}
