import 'package:json_annotation/json_annotation.dart';

part 'complete_sign_up_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class CompleteSignUpRequestDto {
  final String signUpToken;
  final String phoneNumber;
  final String password;

  const CompleteSignUpRequestDto({
    required this.signUpToken,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$CompleteSignUpRequestDtoToJson(this);
}
