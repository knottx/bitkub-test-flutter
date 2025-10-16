import 'package:bitkub_test/data/dtos/user_dto.dart';

abstract class UserRemoteDataSource {
  Future<UserDto> me();
}
