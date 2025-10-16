import 'package:bitkub_test/data/api_client/api_client.dart';
import 'package:bitkub_test/data/data_sources/auth_remote/user_remote/user_remote_data_source.dart';
import 'package:bitkub_test/data/dtos/user_dto.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl(
    this._apiClient,
  );

  @override
  Future<UserDto> me() async {
    final response = await _apiClient.get('/users/me');
    return UserDto.fromJson(response);
  }
}
