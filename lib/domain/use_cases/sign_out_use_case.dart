import 'package:bitkub_test/domain/repositories/auth_repository.dart';
import 'package:bitkub_test/domain/store/session_store.dart';
import 'package:bitkub_test/domain/utils/result.dart';

class SignOutUseCase {
  final SessionStore _sessionStore;
  final AuthRepository _authRepository;

  const SignOutUseCase(
    this._sessionStore,
    this._authRepository,
  );

  Future<Result<Unit>> call() async {
    final result = await _authRepository.signOut();
    switch (result) {
      case Success<Unit>():
        _sessionStore.clear();
        return Result.success(Unit());
      case Failure<Unit>():
        return Result.failure(result.error);
    }
  }
}
