import 'package:bitkub_test/data/dtos/requests/submit_otp_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubmitOtpRequestDto', () {
    test('toJson should convert all fields correctly', () {
      const dto = SubmitOtpRequestDto(
        phoneNumber: '+66999999999',
        otp: '123456',
        ref: 'otp_ref_001',
      );

      final json = dto.toJson();

      expect(json, {
        'phoneNumber': '+66999999999',
        'otp': '123456',
        'ref': 'otp_ref_001',
      });
    });
  });
}
