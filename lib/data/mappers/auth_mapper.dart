import 'package:bitkub_test/data/dtos/auth_dto.dart';
import 'package:bitkub_test/domain/entities/auth.dart';

class AuthMapper {
  AuthMapper._();

  static AuthDto toDto(Auth entity) {
    return AuthDto(
      accessToken: entity.accessToken,
    );
  }

  static Auth toEntity(AuthDto dto) {
    return Auth(
      accessToken: dto.accessToken,
    );
  }
}
