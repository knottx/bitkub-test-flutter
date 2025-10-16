import 'package:bitkub_test/data/dtos/auth_dto.dart';
import 'package:bitkub_test/data/dtos/otp_ref.dart';
import 'package:bitkub_test/data/dtos/sign_up_token_dto.dart';
import 'package:bitkub_test/data/repositories/auth_repository_impl.dart';
import 'package:bitkub_test/domain/entities/auth.dart';
import 'package:bitkub_test/domain/entities/otp_ref.dart';
import 'package:bitkub_test/domain/entities/requests/complete_sign_up_request.dart';
import 'package:bitkub_test/domain/entities/requests/sign_in_request.dart';
import 'package:bitkub_test/domain/entities/requests/sign_up_request.dart';
import 'package:bitkub_test/domain/entities/requests/submit_otp_request.dart';
import 'package:bitkub_test/domain/entities/sign_up_token.dart';
import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:bitkub_test/domain/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockAuthRemoteDataSource remote;
  late AuthRepositoryImpl repo;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    repo = AuthRepositoryImpl(remote);
  });

  group('AuthRepositoryImpl.signIn', () {
    test('returns Success(Auth) and passes mapped DTO', () async {
      const req = SignInRequest(
        phoneNumber: '+66999999999',
        password: 'P@ssw0rd',
      );
      when(
        remote.signIn(request: anyNamed('request')),
      ).thenAnswer((_) async => const AuthDto(accessToken: 'token_123'));

      final result = await repo.signIn(request: req);

      expect(result, isA<Result<Auth>>());
      result.when(
        onSuccess: (Auth auth) {
          expect(auth.accessToken, 'token_123');
        },
        onFailure: (_) => fail('Expected success, got failure'),
      );
      verify(
        remote.signIn(request: anyNamed('request')),
      ).called(1);
    });

    test('returns Failure when remote throws AppError', () async {
      when(
        remote.signIn(request: anyNamed('request')),
      ).thenThrow(const AppError('failed'));

      final result = await repo.signIn(
        request: const SignInRequest(
          phoneNumber: '+66',
          password: 'x',
        ),
      );

      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (e) => expect(e.toString(), contains('failed')),
      );
    });
  });

  group('AuthRepositoryImpl.signOut', () {
    test('returns Success(Unit)', () async {
      when(remote.signOut()).thenAnswer((_) async {});

      final result = await repo.signOut();

      verify(remote.signOut()).called(1);
      result.when(
        onSuccess: (_) => expect(true, isTrue),
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('returns Failure on AppError', () async {
      when(remote.signOut()).thenThrow(const AppError('server'));

      final result = await repo.signOut();

      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (e) => expect(e.toString(), contains('server')),
      );
    });
  });

  group('AuthRepositoryImpl.signUp', () {
    test('returns Success(OtpRef) and passes mapped DTO', () async {
      const req = SignUpRequest(phoneNumber: '+6699');
      when(
        remote.signUp(request: anyNamed('request')),
      ).thenAnswer((_) async => const OtpRefDto(ref: 'otp_ref_001'));

      final result = await repo.signUp(request: req);

      result.when(
        onSuccess: (OtpRef r) => expect(r.ref, 'otp_ref_001'),
        onFailure: (_) => fail('Expected success'),
      );
      verify(
        remote.signUp(request: anyNamed('request')),
      ).called(1);
    });

    test('returns Failure on AppError', () async {
      when(
        remote.signUp(request: anyNamed('request')),
      ).thenThrow(const AppError('bad'));

      final result = await repo.signUp(
        request: const SignUpRequest(phoneNumber: '+66'),
      );

      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (e) => expect(e.toString(), contains('bad')),
      );
    });
  });

  group('AuthRepositoryImpl.submitOtp', () {
    test('returns Success(SignUpToken) and passes mapped DTO', () async {
      const req = SubmitOtpRequest(
        phoneNumber: '+6699',
        otp: '123456',
        ref: 'otp_ref_001',
      );
      when(
        remote.submitOtp(request: anyNamed('request')),
      ).thenAnswer(
        (_) async => const SignUpTokenDto(token: 'signup_token_abc'),
      );

      final result = await repo.submitOtp(request: req);

      result.when(
        onSuccess: (SignUpToken t) => expect(t.token, 'signup_token_abc'),
        onFailure: (_) => fail('Expected success'),
      );

      verify(
        remote.submitOtp(request: anyNamed('request')),
      ).called(1);
    });

    test('returns Failure on AppError', () async {
      when(
        remote.submitOtp(request: anyNamed('request')),
      ).thenThrow(const AppError('otp bad'));

      final result = await repo.submitOtp(
        request: const SubmitOtpRequest(
          phoneNumber: '+66',
          otp: '000000',
          ref: 'r',
        ),
      );

      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (e) => expect(e.toString(), contains('otp bad')),
      );
    });
  });

  group('AuthRepositoryImpl.completeSignUp', () {
    test('returns Success(Auth) and passes mapped DTO', () async {
      const req = CompleteSignUpRequest(
        signUpToken: 'signup_token_abc',
        phoneNumber: '+6699',
        password: 'P@ss',
      );
      when(
        remote.completeSignUp(request: anyNamed('request')),
      ).thenAnswer((_) async => const AuthDto(accessToken: 'token_final'));

      final result = await repo.completeSignUp(request: req);

      expect(result, isA<Result<Auth>>());
      result.when(
        onSuccess: (Auth a) {
          expect(a.accessToken, 'token_final');
        },
        onFailure: (_) => fail('Expected success'),
      );
      verify(
        remote.completeSignUp(request: anyNamed('request')),
      ).called(1);
    });

    test('returns Failure on AppError', () async {
      when(
        remote.completeSignUp(request: anyNamed('request')),
      ).thenThrow(const AppError('complete failed'));

      final result = await repo.completeSignUp(
        request: const CompleteSignUpRequest(
          signUpToken: 'x',
          phoneNumber: '+66',
          password: 'p',
        ),
      );

      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (e) => expect(e.toString(), contains('complete failed')),
      );
    });
  });
}
