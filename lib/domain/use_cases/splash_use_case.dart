import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/repositories/token_repository.dart';
import 'package:bitkub_test/domain/repositories/user_repository.dart';
import 'package:bitkub_test/domain/utils/result.dart';

class SplashUseCase {
  final TokenRepository _tokenRepository;
  final UserRepository _userRepository;

  const SplashUseCase(
    this._tokenRepository,
    this._userRepository,
  );

  Future<Result<User?>> call() async {
    final auth = await _tokenRepository.readAuth();
    if (auth == null) return Result.success(null);

    final result = await _userRepository.me();

    switch (result) {
      case Success<User>():
        return Result.success(result.value);
      case Failure<User>():
        await _tokenRepository.clear();
        return Result.failure(result.error);
    }
  }
}
