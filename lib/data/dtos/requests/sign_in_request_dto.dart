import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class SignInRequestDto {
  final String phoneNumber;
  final String password;

  const SignInRequestDto({
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$SignInRequestDtoToJson(this);
}
