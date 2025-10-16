import 'package:bitkub_test/data/data_sources/auth_remote/user_remote/user_remote_data_source.dart';
import 'package:bitkub_test/data/mappers/user_mapper.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/repositories/user_repository.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;

  const UserRepositoryImpl(
    this._remote,
  );

  @override
  Future<Result<User>> me() async {
    try {
      final dto = await _remote.me();
      return Result.success(UserMapper.toEntity(dto));
    } catch (error) {
      return Result.failure(AppError.fromError(error));
    }
  }
}
