import 'package:bitkub_test/data/dtos/otp_ref.dart';
import 'package:bitkub_test/domain/entities/otp_ref.dart';

class OtpRefMapper {
  OtpRefMapper._();

  static OtpRef toEntity(OtpRefDto dto) {
    return OtpRef(ref: dto.ref);
  }
}
