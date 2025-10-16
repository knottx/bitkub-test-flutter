import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/domain/repositories/user_repository.dart';
import 'package:bitkub_test/domain/store/session_store.dart';
import 'package:bitkub_test/domain/utils/result.dart';

class SignInUseCase {
  final SessionStore _sessionStore;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  const SignInUseCase(
    this._sessionStore,
    this._authRepository,
    this._userRepository,
  );

  Future<Result<User>> call(SignInRequest request) async {
    final result = await _authRepository.signIn(
      request: request,
    );

    switch (result) {
      case Success<Auth>():
        await _sessionStore.saveAuth(result.value);
        return _getProfile();
      case Failure<Auth>():
        return Result.failure(result.error);
    }
  }

  Future<Result<User>> _getProfile() async {
    final result = await _userRepository.me();
    switch (result) {
      case Success<User>():
        return Result.success(result.value);
      case Failure<User>():
        return Result.failure(result.error);
    }
  }
}
