import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/use_cases/splash_use_case.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockSessionStore store;
  late MockUserRepository repo;
  late SplashUseCase useCase;

  setUpAll(() {
    provideDummy<Result<User>>(Result.failure(const AppError('dummy')));
  });

  setUp(() {
    store = MockSessionStore();
    repo = MockUserRepository();
    useCase = SplashUseCase(store, repo);
  });

  group('SplashUseCase', () {
    test(
      'returns Success(null) when no auth; does not call repo.me()',
      () async {
        when(store.readAuth()).thenAnswer((_) async => null);

        final result = await useCase.call();

        result.when(
          onSuccess: (user) => expect(user, isNull),
          onFailure: (e) => fail('Expected success(null), got $e'),
        );
        verify(store.readAuth()).called(1);
        verifyNever(repo.me());
      },
    );

    test(
      'returns Success(user) when auth exists and repo.me() succeeds',
      () async {
        when(
          store.readAuth(),
        ).thenAnswer((_) async => const Auth(accessToken: 'access_token_123'));

        const user = User(
          id: 'u1',
          firstName: 'Knot',
          lastName: 'Tippun',
          phoneNumber: '+66999999999',
        );
        when(repo.me()).thenAnswer((_) async => Result.success(user));

        final result = await useCase.call();

        verify(store.readAuth()).called(1);
        verify(repo.me()).called(1);
        verifyNever(store.clear());

        result.when(
          onSuccess: (u) => expect(u, equals(user)),
          onFailure: (e) => fail('Expected success(user), got $e'),
        );
      },
    );

    test(
      'returns Failure when auth exists but repo.me() fails; clears SessionStore',
      () async {
        when(store.readAuth()).thenAnswer((_) async => const Auth());
        final err = const AppError('unauthorized');
        when(repo.me()).thenAnswer((_) async => Result.failure(err));
        when(store.clear()).thenAnswer((_) async {});

        final result = await useCase.call();

        verify(store.readAuth()).called(1);
        verify(repo.me()).called(1);
        verify(store.clear()).called(1);

        result.when(
          onSuccess: (_) => fail('Expected failure'),
          onFailure: (e) => expect(e.toString(), contains('unauthorized')),
        );
      },
    );
  });
}
