import 'package:bitkub_test/data/dtos/user_dto.dart';
import 'package:bitkub_test/domain/entities/user.dart';

class UserMapper {
  UserMapper._();

  static User toEntity(UserDto dto) {
    return User(
      id: dto.id,
      firstName: dto.firstName,
      lastName: dto.lastName,
      phoneNumber: dto.phoneNumber,
    );
  }
}
