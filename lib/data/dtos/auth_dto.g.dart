// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthDto _$AuthDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthDto', json, ($checkedConvert) {
      final val = AuthDto(
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AuthDtoToJson(AuthDto instance) => <String, dynamic>{
  'accessToken': ?instance.accessToken,
};
