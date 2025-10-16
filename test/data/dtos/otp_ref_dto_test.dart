import 'package:bitkub_test/data/dtos/otp_ref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OtpRefDto', () {
    test('fromJson should parse correctly', () {
      const json = {'ref': 'ABCXYZ'};
      final dto = OtpRefDto.fromJson(json);

      expect(dto.ref, 'ABCXYZ');
    });

    test('fromJson should handle null ref', () {
      const json = {'ref': null};
      final dto = OtpRefDto.fromJson(json);

      expect(dto.ref, isNull);
    });

    test('fromJson should handle missing key safely', () {
      final dto = OtpRefDto.fromJson({});
      expect(dto.ref, isNull);
    });
  });
}
