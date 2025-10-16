import 'package:bitkub_test/data/dtos/requests/sign_up_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpRequestDto', () {
    test('toJson should convert correctly', () {
      const dto = SignUpRequestDto(
        phoneNumber: '+66999999999',
      );

      final json = dto.toJson();

      expect(json, {
        'phoneNumber': '+66999999999',
      });
    });
  });
}
