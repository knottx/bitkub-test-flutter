import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class SignUpRequestDto {
  final String phoneNumber;

  const SignUpRequestDto({
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => _$SignUpRequestDtoToJson(this);
}
