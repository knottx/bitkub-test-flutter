import 'package:bitkub_test/domain/use_cases/sign_out_use_case.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<Unit>>(Result.failure(const AppError('dummy')));
  });

  late MockTokenRepository tokenRepo;
  late MockAuthRepository repo;
  late SignOutUseCase useCase;

  setUp(() {
    tokenRepo = MockTokenRepository();
    repo = MockAuthRepository();
    useCase = SignOutUseCase(
      tokenRepo,
      repo,
    );
  });

  test(
    'success: calls repo.signOut, clears store, returns success(Unit)',
    () async {
      when(repo.signOut()).thenAnswer((_) async => Result.success(Unit()));
      when(tokenRepo.clear()).thenAnswer((_) async {});

      final result = await useCase.call();

      verify(repo.signOut()).called(1);
      verify(tokenRepo.clear()).called(1);

      result.when(
        onSuccess: (_) => expect(true, isTrue),
        onFailure: (e) => fail('Expected success, got $e'),
      );
    },
  );

  test(
    'failure: calls repo.signOut, does NOT clear store, propagates failure',
    () async {
      when(
        repo.signOut(),
      ).thenAnswer((_) async => Result.failure(const AppError('server down')));

      final result = await useCase.call();

      verify(repo.signOut()).called(1);
      verifyNever(tokenRepo.clear());

      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (e) => expect(e.toString(), contains('server down')),
      );
    },
  );
}
