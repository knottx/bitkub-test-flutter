import 'package:bitkub_test/data/dtos/requests/submit_otp_request_dto.dart';
import 'package:bitkub_test/domain/entities/requests/submit_otp_request.dart';

class SubmitOtpRequestMapper {
  SubmitOtpRequestMapper._();

  static SubmitOtpRequestDto toDto(SubmitOtpRequest entity) {
    return SubmitOtpRequestDto(
      phoneNumber: entity.phoneNumber,
      otp: entity.otp,
      ref: entity.ref,
    );
  }
}
