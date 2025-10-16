import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/repositories/user_repository.dart';
import 'package:bitkub_test/domain/store/session_store.dart';
import 'package:bitkub_test/domain/utils/result.dart';

class SplashUseCase {
  final SessionStore _sessionStore;
  final UserRepository _userRepository;

  const SplashUseCase(
    this._sessionStore,
    this._userRepository,
  );

  Future<Result<User?>> call() async {
    final auth = await _sessionStore.readAuth();
    if (auth == null) return Result.success(null);

    final result = await _userRepository.me();

    switch (result) {
      case Success<User>():
        return Result.success(result.value);
      case Failure<User>():
        await _sessionStore.clear();
        return Result.failure(result.error);
    }
  }
}
