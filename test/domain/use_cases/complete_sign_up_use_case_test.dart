import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/requests/complete_sign_up_request.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/use_cases/complete_sign_up_use_case.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Result<Auth>>(Result.failure(const AppError('dummy-auth')));
    provideDummy<Result<User>>(Result.failure(const AppError('dummy-user')));
  });

  late MockSessionStore store;
  late MockAuthRepository authRepo;
  late MockUserRepository userRepo;
  late CompleteSignUpUseCase useCase;

  setUp(() {
    store = MockSessionStore();
    authRepo = MockAuthRepository();
    userRepo = MockUserRepository();
    useCase = CompleteSignUpUseCase(store, authRepo, userRepo);
  });

  group('CompleteSignUpUseCase', () {
    test(
      'success: completeSignUp -> saveAuth -> me -> Success(User)',
      () async {
        const req = CompleteSignUpRequest(
          signUpToken: 'tok_abc',
          phoneNumber: '+66999999999',
          password: 'P@ssw0rd!',
        );
        const auth = Auth(
          accessToken: 'access_123',
        );
        const user = User(
          id: 'u1',
          firstName: 'Knot',
          lastName: 'Tippun',
          phoneNumber: '+66999999999',
        );

        when(
          authRepo.completeSignUp(request: req),
        ).thenAnswer((_) async => Result.success(auth));
        when(store.saveAuth(auth)).thenAnswer((_) async {});
        when(userRepo.me()).thenAnswer((_) async => Result.success(user));

        final result = await useCase.call(req);

        verifyInOrder([
          authRepo.completeSignUp(request: req),
          store.saveAuth(auth),
          userRepo.me(),
        ]);
        verifyNoMoreInteractions(authRepo);
        verifyNoMoreInteractions(userRepo);

        result.when(
          onSuccess: (u) => expect(u, equals(user)),
          onFailure: (e) => fail('Expected success, got $e'),
        );
      },
    );

    test(
      'failure: completeSignUp fails -> no saveAuth, no me -> Failure(e)',
      () async {
        const req = CompleteSignUpRequest(
          signUpToken: 'tok_bad',
          phoneNumber: '+66',
          password: 'weak',
        );
        final err = const AppError('complete failed');
        when(
          authRepo.completeSignUp(request: req),
        ).thenAnswer((_) async => Result.failure(err));

        final result = await useCase.call(req);

        verify(authRepo.completeSignUp(request: req)).called(1);
        verifyNever(store.saveAuth(any));
        verifyNever(userRepo.me());

        result.when(
          onSuccess: (_) => fail('Expected failure'),
          onFailure: (e) => expect(e.toString(), contains('complete failed')),
        );
      },
    );

    test(
      'completeSignUp success but me fails -> saveAuth called -> Failure(e)',
      () async {
        const req = CompleteSignUpRequest(
          signUpToken: 'tok_ok',
          phoneNumber: '+66',
          password: 'StrongP@ss',
        );
        const auth = Auth(accessToken: 't_ok');
        final err = const AppError('server busy');

        when(
          authRepo.completeSignUp(request: req),
        ).thenAnswer((_) async => Result.success(auth));
        when(store.saveAuth(auth)).thenAnswer((_) async {});
        when(userRepo.me()).thenAnswer((_) async => Result.failure(err));

        final result = await useCase.call(req);

        verifyInOrder([
          authRepo.completeSignUp(request: req),
          store.saveAuth(auth),
          userRepo.me(),
        ]);

        result.when(
          onSuccess: (_) => fail('Expected failure'),
          onFailure: (e) => expect(e.toString(), contains('server busy')),
        );
      },
    );

    test('passes the same request object to repo.completeSignUp', () async {
      const req = CompleteSignUpRequest(
        signUpToken: 'tok_same',
        phoneNumber: '+66',
        password: 'OkPass123',
      );
      when(
        authRepo.completeSignUp(request: anyNamed('request')),
      ).thenAnswer((_) async => Result.failure(const AppError('x')));

      await useCase.call(req);

      verify(authRepo.completeSignUp(request: req)).called(1);
    });
  });
}
