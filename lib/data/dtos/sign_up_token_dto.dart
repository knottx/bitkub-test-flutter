import 'package:json_annotation/json_annotation.dart';

part 'sign_up_token_dto.g.dart';

@JsonSerializable(createToJson: false)
class SignUpTokenDto {
  final String? token;

  const SignUpTokenDto({
    this.token,
  });

  factory SignUpTokenDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpTokenDtoFromJson(json);
}
