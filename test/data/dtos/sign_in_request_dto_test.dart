import 'package:bitkub_test/data/dtos/requests/sign_in_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInRequestDto', () {
    test('toJson should convert correctly', () {
      const dto = SignInRequestDto(
        phoneNumber: '+66999999999',
        password: 'StrongP@ssw0rd',
      );

      final json = dto.toJson();

      expect(json, {
        'phoneNumber': '+66999999999',
        'password': 'StrongP@ssw0rd',
      });
    });
  });
}
