import 'package:bitkub_test/data/dtos/requests/complete_sign_up_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CompleteSignUpRequestDto', () {
    test('toJson should convert correctly', () {
      const dto = CompleteSignUpRequestDto(
        signUpToken: 'signup_token_123',
        phoneNumber: '+66999999999',
        password: 'P@ssw0rd!',
      );

      final json = dto.toJson();

      expect(json, {
        'signUpToken': 'signup_token_123',
        'phoneNumber': '+66999999999',
        'password': 'P@ssw0rd!',
      });
    });
  });
}
