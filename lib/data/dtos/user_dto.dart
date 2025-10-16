import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(createToJson: false)
class UserDto {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  const UserDto({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
