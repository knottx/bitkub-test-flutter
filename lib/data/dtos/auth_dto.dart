import 'package:json_annotation/json_annotation.dart';

part 'auth_dto.g.dart';

@JsonSerializable()
class AuthDto {
  final String? accessToken;

  const AuthDto({
    this.accessToken,
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) =>
      _$AuthDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDtoToJson(this);
}
