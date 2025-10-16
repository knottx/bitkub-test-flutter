import 'package:json_annotation/json_annotation.dart';

part 'submit_otp_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class SubmitOtpRequestDto {
  final String phoneNumber;
  final String otp;
  final String ref;

  const SubmitOtpRequestDto({
    required this.phoneNumber,
    required this.otp,
    required this.ref,
  });

  Map<String, dynamic> toJson() => _$SubmitOtpRequestDtoToJson(this);
}
