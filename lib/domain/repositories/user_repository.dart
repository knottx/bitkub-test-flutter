import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/utils/result.dart';

abstract class UserRepository {
  Future<Result<User>> me();
}
