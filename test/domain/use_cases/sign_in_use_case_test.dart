import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';
import 'package:bitkub_test/domain/entities/user.dart';
import 'package:bitkub_test/domain/use_cases/sign_in_use_case.dart';
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

  late MockTokenRepository tokenRepo;
  late MockAuthRepository authRepo;
  late MockUserRepository userRepo;
  late SignInUseCase useCase;

  setUp(() {
    tokenRepo = MockTokenRepository();
    authRepo = MockAuthRepository();
    userRepo = MockUserRepository();
    useCase = SignInUseCase(
      tokenRepo,
      authRepo,
      userRepo,
    );
  });

  group('SignInUseCase', () {
    test('success: signIn -> saveAuth -> me -> Success(User)', () async {
      const req = SignInRequest(
        phoneNumber: '+66999999999',
        password: 'P@ssw0rd',
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
        authRepo.signIn(request: req),
      ).thenAnswer((_) async => Result.success(auth));
      when(tokenRepo.saveAuth(auth)).thenAnswer((_) async {});
      when(userRepo.me()).thenAnswer((_) async => Result.success(user));

      final result = await useCase(req);

      verifyInOrder([
        authRepo.signIn(request: req),
        tokenRepo.saveAuth(auth),
        userRepo.me(),
      ]);
      verifyNoMoreInteractions(authRepo);
      verifyNoMoreInteractions(userRepo);

      result.when(
        onSuccess: (u) => expect(u, equals(user)),
        onFailure: (e) => fail('Expected success, got $e'),
      );
    });

    test('failure: signIn fails -> no saveAuth, no me -> Failure(e)', () async {
      const req = SignInRequest(phoneNumber: '+66', password: 'bad');
      final err = const AppError('invalid credentials');
      when(
        authRepo.signIn(request: req),
      ).thenAnswer((_) async => Result.failure(err));

      final result = await useCase(req);

      verify(authRepo.signIn(request: req)).called(1);
      verifyNever(tokenRepo.saveAuth(any));
      verifyNever(userRepo.me());

      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (e) => expect(e.toString(), contains('invalid credentials')),
      );
    });

    test(
      'signIn success but me fails -> saveAuth called -> Failure(e)',
      () async {
        const req = SignInRequest(phoneNumber: '+66', password: 'ok');
        const auth = Auth(accessToken: 't_ok');
        final err = const AppError('server busy');

        when(
          authRepo.signIn(request: req),
        ).thenAnswer((_) async => Result.success(auth));
        when(tokenRepo.saveAuth(auth)).thenAnswer((_) async {});
        when(userRepo.me()).thenAnswer((_) async => Result.failure(err));

        final result = await useCase(req);

        verifyInOrder([
          authRepo.signIn(request: req),
          tokenRepo.saveAuth(auth),
          userRepo.me(),
        ]);
        result.when(
          onSuccess: (_) => fail('Expected failure'),
          onFailure: (e) => expect(e.toString(), contains('server busy')),
        );
      },
    );

    test('passes the same request object to repo.signIn', () async {
      const req = SignInRequest(phoneNumber: '+66', password: 'ok');
      when(
        authRepo.signIn(request: anyNamed('request')),
      ).thenAnswer((_) async => Result.failure(const AppError('x')));

      await useCase.call(req);

      verify(authRepo.signIn(request: req)).called(1);
    });
  });
}
