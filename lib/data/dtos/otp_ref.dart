import 'package:json_annotation/json_annotation.dart';

part 'otp_ref.g.dart';

@JsonSerializable(createToJson: false)
class OtpRefDto {
  final String? ref;

  const OtpRefDto({
    this.ref,
  });

  factory OtpRefDto.fromJson(Map<String, dynamic> json) =>
      _$OtpRefDtoFromJson(json);
}
