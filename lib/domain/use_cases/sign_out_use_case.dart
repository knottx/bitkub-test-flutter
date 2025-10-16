import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/domain/repositories/token_repository.dart';
import 'package:bitkub_test/domain/utils/result.dart';

class SignOutUseCase {
  final TokenRepository _tokenRepository;
  final AuthRepository _authRepository;

  const SignOutUseCase(
    this._tokenRepository,
    this._authRepository,
  );

  Future<Result<Unit>> call() async {
    final result = await _authRepository.signOut();
    switch (result) {
      case Success<Unit>():
        await _tokenRepository.clear();
        return Result.success(Unit());
      case Failure<Unit>():
        return Result.failure(result.error);
    }
  }
}
